Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab2KOXoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:44:12 -0500
Received: from bsmtp5.bon.at ([195.3.86.187]:12409 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851Ab2KOXoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:44:10 -0500
From: Markus Grabner <grabner@icg.tugraz.at>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, devel@driverdev.osuosl.org,
        line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/8] staging: line6: wrap >80 char lines in capture.c
Date: Fri, 16 Nov 2012 00:43:48 +0100
Message-ID: <1475639.oCQjCBj5TR@mark>
Organization: Graz University of Technology
User-Agent: KMail/4.9.2 (Linux/3.4.11-2.16-desktop; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353017551.20648.18.camel@joe-AO722>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com> <1602710.lBylyCQOHr@medialab> <1353017551.20648.18.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012 14:12:31 Joe Perches wrote:
> On Thu, 2012-11-15 at 22:03 +0100, Markus Grabner wrote:
> > Am Mittwoch, 14. November 2012, 17:33:05 schrieb Dan Carpenter:
> > > The reason this is hitting the 80 character limit is because
> > > "LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM" is 35 characters long.  It
> > > isn't even clear from the name what it holds.  It's just a very crap
> > > name.
> > 
> > Please refer to the file pcm.h for a detailed documentation of this and
> > similar names (in fact, the documentation explains the LINE6_BIT_PCM_*
> > names instead, but I bevlieve the correspondence is obvious). It's hard
> > to define a shorter name which is at the same time descriptive,
> > consistent, and not to be confused with related names.
> > 
> > Should such documentation be moved to a separate file (e.g.,
> > "Documentation/sound/alsa/line6usb.txt")?
> 
> Documenting poor naming choices doesn't make it better.
Yes, but the documentation might help understanding why a particular naming 
was chosen and that it might not be as poor as it seemed at first sight. I 
assume that you are aware of the meaning of the LINE6_INDEX_PCM_* symbols (and 
of the issues that were fixed by introducing them), so which naming scheme 
would you propose instead?

	Kind regards,
		Markus



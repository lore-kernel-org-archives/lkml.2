Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2KOWMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:12:33 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40258 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751757Ab2KOWMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:12:31 -0500
Message-ID: <1353017551.20648.18.camel@joe-AO722>
Subject: Re: [PATCH 1/8] staging: line6: wrap >80 char lines in capture.c
From: Joe Perches <joe@perches.com>
To: Markus Grabner <grabner@icg.tugraz.at>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, devel@driverdev.osuosl.org,
        line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 15 Nov 2012 14:12:31 -0800
In-Reply-To: <1602710.lBylyCQOHr@medialab>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
	 <1352636686-31170-2-git-send-email-stefanha@gmail.com>
	 <20121114143305.GH11515@mwanda> <1602710.lBylyCQOHr@medialab>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 22:03 +0100, Markus Grabner wrote:
> Am Mittwoch, 14. November 2012, 17:33:05 schrieb Dan Carpenter:
> > The reason this is hitting the 80 character limit is because
> > "LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM" is 35 characters long.  It
> > isn't even clear from the name what it holds.  It's just a very crap
> > name.
> Please refer to the file pcm.h for a detailed documentation of this and 
> similar names (in fact, the documentation explains the LINE6_BIT_PCM_* names 
> instead, but I bevlieve the correspondence is obvious). It's hard to define a 
> shorter name which is at the same time descriptive, consistent, and not to be 
> confused with related names.
> 
> Should such documentation be moved to a separate file (e.g., 
> "Documentation/sound/alsa/line6usb.txt")?

Documenting poor naming choices doesn't make it better.



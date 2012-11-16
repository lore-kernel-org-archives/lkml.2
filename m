Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2KPAbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:31:00 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35849 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751388Ab2KPAa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:30:57 -0500
Message-ID: <1353025857.24310.15.camel@joe-AO722>
Subject: Re: [PATCH 1/8] staging: line6: wrap >80 char lines in capture.c
From: Joe Perches <joe@perches.com>
To: Markus Grabner <grabner@icg.tugraz.at>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, devel@driverdev.osuosl.org,
        line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 15 Nov 2012 16:30:57 -0800
In-Reply-To: <1475639.oCQjCBj5TR@mark>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
	 <1602710.lBylyCQOHr@medialab> <1353017551.20648.18.camel@joe-AO722>
	 <1475639.oCQjCBj5TR@mark>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 00:43 +0100, Markus Grabner wrote:
> On Thursday 15 November 2012 14:12:31 Joe Perches wrote:
> > On Thu, 2012-11-15 at 22:03 +0100, Markus Grabner wrote:
> > > Am Mittwoch, 14. November 2012, 17:33:05 schrieb Dan Carpenter:
> > > > The reason this is hitting the 80 character limit is because
> > > > "LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM" is 35 characters long.  It
> > > > isn't even clear from the name what it holds.  It's just a very crap
> > > > name.
> > > 
> > > Please refer to the file pcm.h for a detailed documentation of this and
> > > similar names (in fact, the documentation explains the LINE6_BIT_PCM_*
> > > names instead, but I bevlieve the correspondence is obvious). It's hard
> > > to define a shorter name which is at the same time descriptive,
> > > consistent, and not to be confused with related names.
> > > 
> > > Should such documentation be moved to a separate file (e.g.,
> > > "Documentation/sound/alsa/line6usb.txt")?
> > 
> > Documenting poor naming choices doesn't make it better.
> Yes, but the documentation might help understanding why a particular naming 
> was chosen and that it might not be as poor as it seemed at first sight. I 
> assume that you are aware of the meaning of the LINE6_INDEX_PCM_* symbols (and 
> of the issues that were fixed by introducing them), so which naming scheme 

Hi Markus

Dunno why they were introduced, but I think
several things could be shorter as to me
none of these longish L6_BIT(foo) elements
means much and I'd need to read the code
to figure them out anyway.

the LINE6_ prefix is excessive,
L6_ would probably be fine.
(and that goes for all the functions too)

CAPTURE/RECORD could be RD/WR
MONITOR could be MON
IMPULSE could be IRM

BUFFER could be I
STREAM could be O
(or the other way 'round)

etc..., cheers, Joe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1GDJTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:19:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:47577 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1GDJT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:19:29 -0400
Date: Mon, 4 Jul 2011 11:10:07 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thomas@tungstengraphics.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] gma500: fix compiler warnings and format string
In-Reply-To: <20110703133732.4e2ed436@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1107041109410.24059@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107030914100.16316@swampdragon.chaosbits.net> <20110703133732.4e2ed436@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-996775948-1309770607=:24059"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-996775948-1309770607=:24059
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Sun, 3 Jul 2011, Alan Cox wrote:

> On Sun, 3 Jul 2011 09:16:13 +0200 (CEST)
> Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > This patch fixes these compiler warnings:
> > 
> >   CC      drivers/staging/gma500/psb_gtt.o
> > drivers/staging/gma500/psb_gtt.c: In function ¡psb_gtt_insert¢:
> > drivers/staging/gma500/psb_gtt.c:81:33: warning: unused variable ¡dev_priv¢ [-Wunused-variable]
> > drivers/staging/gma500/psb_gtt.c: In function ¡psb_gtt_pin¢:
> > drivers/staging/gma500/psb_gtt.c:237:2: warning: ¡ret¢ may be used uninitialized in this function [-Wuninitialized]
> > 
> > It also fixes up the format string used in DRM_DEBUG() in
> > drivers/staging/gma500/psb_gtt.c:psb_gtt_init() - the string required
> > two arguments but only one was supplied.
> > 
> > While reading through the file I also deleted what trailing whitespace
> > I encountered.
> 
> Unfortunately this file doesn't even exist in the working tree any more.
> Please wait until Greg has taken the patch set I sent him to replace the
> one that didn't apply, and the patch series after that (and quite
> possibly the one after that assuming I can get Cedartrail to work next
> week).
> 
Ok. Thank you for the info. I'll leave gma500 alone for a couple of weeks.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-996775948-1309770607=:24059--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1ALNpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:45:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:43572 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab1ALNpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:45:12 -0500
Date: Wed, 12 Jan 2011 13:45:09 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for rc1
In-Reply-To: <AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985284609-1412892958-1294839909=:8212"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985284609-1412892958-1294839909=:8212
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


> On Wed, Jan 12, 2011 at 1:21 PM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
> > Am 12.01.2011 00:28, schrieb Linus Torvalds:
> >> On Tue, Jan 11, 2011 at 3:20 PM, Christian Borntraeger
> >> <borntraeger@de.ibm.com> wrote:
> >>>
> >>> Now nouveau framebuffer is completely broken on my T61p (01:00.0 VGA compatible controller: nVidia Corporation G84M [Quadro FX 570M] (rev a1))
> >>> During startup the framebuffer shows only stripes and a blank
> >>> screen after suspend/resume.
> >>> I also see lots of TRAP messages. (see below).
> >>> X11 seems to work fine though...
> >>
> >> Can you try to bisect?
> >
> > dfe63bb0ad9810db13aab0058caba97866e0a681 is the first bad commit
> > commit dfe63bb0ad9810db13aab0058caba97866e0a681
> > Author: James Simmons <jsimmons@infradead.org>
> > Date:   Thu Dec 23 16:40:37 2010 +0000
> >
> >    drm: Update fbdev fb_fix_screeninfo
> >
> >
> > Reverting this on top of todays git also fixes my problem.
> >
> > Christian
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> I tested the revert: the boot screen did change the resolution
> (without it don't), but my PC still hangs. (using an nvidia 8800GT).

Try my most recent patch. Where does it hang at? Any logs?

--1985284609-1412892958-1294839909=:8212--

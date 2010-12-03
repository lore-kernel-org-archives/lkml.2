Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0LCKYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:24:39 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54015 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab0LCKYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:24:38 -0500
Date: Fri, 03 Dec 2010 19:01:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [GIT PULL] Samsung fixes for 2.6.37-rc4
In-reply-to: <AANLkTinuYg2LzwZJUnpT0-b3Gi+vOJr-_fi4o874DAFG@mail.gmail.com>
To: "'Darius Augulis'" <augulis.darius@gmail.com>, ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-id: <015301cb92d1$132c94a0$3985bde0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcuQpiA8plnQaHNHQkmMcpA1jaENqQBTpoVA
References: <008201cb8c58$363980e0$a2ac82a0$%kim@samsung.com>
 <4CEFFBE6.9040909@gmail.com> <006601cb9024$c9369110$5ba3b330$%kim@samsung.com>
 <AANLkTinuYg2LzwZJUnpT0-b3Gi+vOJr-_fi4o874DAFG@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius Augulis wrote:
> 
> Hi Ben, Kukjin,
> 
Hi Darius,
Ok...I will apply this in my tree for -next with Ben's ack.

Ben, if any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> could you please both find out who must 'handle' it?
> Do you think it's normal to force people to ping you for the same four
> lines patch for 4 months or more?
> I think, it's at least not optimal and not good for kernel development
> process.
> 
> 
> On Tue, Nov 30, 2010 at 2:23 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Darius Augulis wrote:
> >>
> >> Hi Kukjin,
> >>
> > Hi,
> >
> >> you have missed "serial: samsung: fix device name" again.
> >> Please, don't forget to add it to your tree, better do it right now.
> >> Perhaps it's fifth or sixth time when remind about that...
> >>
> > I remember, I've replied about that like following.
> > Maybe you missed...
> >
> > ---
> >> you have missed "serial: samsung: fix device name" which is hanging
here
> >> for a long time and was decided to merge in 2.6.37-rc1.
> >> Please, pick it up.
> >>
> > Hmm...I thought it should be handled by Ben Dooks at that time.
> >
> > Anyway, as Ben said, I'm thinking it should be sent upstream when merge
> > window
> > even though have missed it in the last merge window.
> >
> > However, if Ben is ok to merge this during 37-rc, will merge it into
> > s5p-fixes-
> > for-linus for 37-rc.
> > ---
> >
> > But I still thinking it should be handled by Ben Dooks...
> 
> handle what? You have Ben ack to merge it. I'm confused how 'optimal'
> is development process when have to ping the same people for the same
> four lines patch for 4 months. You both  Do you think I really have to
> ask help for arm, serial or linux-stable maintainers to 'hadle' this?
> Because I gave up believing it's possible to do by samsung
> maintainers.


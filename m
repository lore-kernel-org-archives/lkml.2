Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab1LNXd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:33:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43847 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab1LNXdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:33:23 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-86-4ee932410727
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Will Deacon'" <will.deacon@arm.com>
Cc: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1323838630.18517.1.camel@phoenix>
 <20111214123244.GE7122@mudshark.cambridge.arm.com>
 <20111214191205.GF14542@n2100.arm.linux.org.uk>
In-reply-to: <20111214191205.GF14542@n2100.arm.linux.org.uk>
Subject: RE: [linux-next] make  s5p64x0_defconfig build error
Date: Thu, 15 Dec 2011 08:33:18 +0900
Message-id: <028901ccbab8$c2c43890$484ca9b0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy6lFH3NmvMnJl/TfyNnGKw04ueWAAI8bQw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> 
> On Wed, Dec 14, 2011 at 12:32:44PM +0000, Will Deacon wrote:
> > On Wed, Dec 14, 2011 at 04:57:10AM +0000, Axel Lin wrote:
> > > I got below build error on linux-next 20111213.
> > >
> > >   CC      arch/arm/kernel/process.o
> > > In file included from arch/arm/mach-s5p64x0/include/mach/system.h:16,
> > >                  from arch/arm/kernel/process.c:64:
> > > arch/arm/plat-samsung/include/plat/system-reset.h:19:2: error: #error
> Fix me up
> > > make[1]: *** [arch/arm/kernel/process.o] Error 1
> > > make: *** [arch/arm/kernel] Error 2
> >
> > The clue is in the commit message:
> >
> > commit d0f7e2beabe6a116152ccc31959b6654b6ef0071
> > Author: Russell King <rmk+kernel@arm.linux.org.uk>
> > Date:   Tue Dec 6 12:57:02 2011 +0000
> >
> >     ARM: restart: Temporary #error to persuade platform maintainers to
> take the restart changes seriously
> >
> >     Force builds to fail to ensure that platform maintainers take the
> >     restart changes seriously, and sort out fixing their code before the
> >     next merge window.
> >
> >     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Indeed, and note the date, and how long its taken for just one of the
> platforms to be noticed.
> 
> It seems to me that no one really cares about whether six of the seven
> platforms which have the #error build or don't build, so I really think
> there's a simple solution to this at the next merge window - delete any
> platform which hasn't _at_ _least_ responded with a proposed patch to
> this.
> 
> The platform maintainers have had _enough_ notice of this - by not
> responding, they're quite simply an obstacle to further consolidation,
> and we're not going to go through months of waiting for their response
> time and time again.
> 
> I've posted the patches to the mailing list, I've copied them asking
> for help, I've chased them several times, and now they have a #error
> to deal with.  If none of this gets their attention (it seems it
> doesn't), then frankly their platform is unmaintained, it will be
> broken at the next merge window, and therefore _should_ be deleted.
> 
> So... unless things change, we can expect Gemini, almost all Samsung
> stuff, shmobile, vt8500, and Telechips TCC8k to be at least broken at
> the next merge window.

Axel and Will, thanks for pointing out.

Oops, I couldn't have much time to follow up :(
But let me look at that in this weekend and I know, it can be escaped before
merge window :)

Anyway, sorry for noisy.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


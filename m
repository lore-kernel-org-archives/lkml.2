Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1HOJrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 05:47:46 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:51537 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900Ab1HOJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 05:47:42 -0400
Date: Mon, 15 Aug 2011 11:12:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Leo Yan <leoy@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
Message-ID: <20110815091245.GC32705@game.jcrosoft.org>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
 <1313377893.14434.5.camel@Lily>
 <CAMPhdO8rkct4H74zXBzaDa183u5vrPArerXgiNXwvQWzZT67Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMPhdO8rkct4H74zXBzaDa183u5vrPArerXgiNXwvQWzZT67Ng@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16683021870519921526
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvjedrudefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:43 Mon 15 Aug     , Eric Miao wrote:
> On Mon, Aug 15, 2011 at 11:11 AM, Haojian Zhuang
> <haojian.zhuang@marvell.com> wrote:
> > On Sun, 2011-08-14 at 20:09 -0700, Leo Yan wrote:
> >> On mmp platform, there have two sram banks:
> >> audio sram bank, and internal sram bank for video and PM.
> >> So add the sram module to manage these sram banks.
> >>
> >> And register the sram banks so can dynamically alloc/free
> >> the buffer.
> >>
> >> Leo Yan (3):
> >>   ARM: mmp: add sram allocator
> >>   ARM: mmp: register audio sram bank
> >>   ARM: mmp: register internal sram bank
> >>
> >>  arch/arm/Kconfig                      |    1 +
> >>  arch/arm/mach-mmp/Makefile            |    2 +-
> >>  arch/arm/mach-mmp/brownstone.c        |   11 ++
> >>  arch/arm/mach-mmp/include/mach/mmp2.h |   13 +++
> >>  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
> >>  arch/arm/mach-mmp/mmp2.c              |    3 +
> >>  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
> >>  7 files changed, 232 insertions(+), 1 deletions(-)
> >>  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
> >>  create mode 100644 arch/arm/mach-mmp/sram.c
> >>
> > Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> 
> Looks good to me. Thanks Haojian. Applied to -devel.
I've some reserve on the named pool they need to be managed at generic level
not here

Best Regards,
J.

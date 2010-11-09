Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0KIWFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:05:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57442 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0KIWE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZgWCz9lwDYREmzpIAUpLAe5mkwoi8Tr1PLEFGzM93BGCceAvdiTEnQ+n+wnA7B+qbw
         vXjw1DPuVnzcxbmmB3onsag4QnwahsBwfjlUPd1nwKF5FPGRURzYXXlS5Ov/SXOBFfn3
         ST6OQvPQOg6r7L4YfVtbjdG4usmnhuZ+Jqa+A=
MIME-Version: 1.0
In-Reply-To: <201011091729.17679.arnd@arndb.de>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
Date: Wed, 10 Nov 2010 00:04:58 +0200
Message-ID: <AANLkTikK=Vr4PkQYzBqS97beuZbTUWq5Xp=7=Uw6QcCn@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:29 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 09 November 2010, Felipe Contreras wrote:
>> Felipe Contreras (14):
>>       Revert "staging: tidspbridge - update Kconfig to select IOMMU module"
>>       Revert "staging: tidspbridge - remove dmm custom module"
>>       Revert "staging: tidspbridge - deprecate reserve/unreserve_memory funtions"
>>       Revert "staging: tidspbridge - remove reserved memory clean up"
>>       Revert "staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct"
>>       Revert "staging: tidspbridge - move all iommu related code to a new file"
>>       Revert "staging: tidspbridge - remove hw directory"
>>       Revert "staging: tidspbridge - fix mmufault support"
>>       Revert "staging: tidspbridge - remove custom mmu code from tiomap3430.c"
>>       Revert "staging: tidspbridge - rename bridge_brd_mem_map/unmap to a proper name"
>>       Revert "staging: tidspbridge - move shared memory iommu maps to tiomap3430.c"
>>       Revert "staging: tidspbridge: replace iommu custom for opensource implementation"
>
> That adds quite a lot of crap back in that was removed by Fernando earlier:
>
>  44 files changed, 3733 insertions(+), 847 deletions(-)
>
> It may have been premature to merge the patches as you say, but now that
> they are in, I'd vote for giving Fernando a chance to fix up any damage
> that was done in the process rather than just reverting all the useful
> changes.

The changes from Fernando require changes in other trees: arm, omap.
These cannot get into 2.6.37, and I have my doubts they would get into
2.6.38, as I haven't seen those ack'ed yet.

Moreover, I have applied all the patches Fernando has sent, and I
still haven't seen this driver working with the new iommu code.

So, sure, these patches are good, we (Nokia), requested them years
ago, but right now there's no way to get this driver working with them
on 2.6.37. I would rather have a working driver for once on a vanilla
kernel. It is really tiring to point people to different places to get
working code depending on which week they ask.

-- 
Felipe Contreras

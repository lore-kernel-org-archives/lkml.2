Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0KIQvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:51:33 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49087 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768Ab0KIQva convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:51:30 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 11:51:30 EST
MIME-Version: 1.0
In-Reply-To: <201011091729.17679.arnd@arndb.de>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
	<AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
	<201011091729.17679.arnd@arndb.de>
Date: Tue, 9 Nov 2010 10:46:02 -0600
Message-ID: <AANLkTikMjAh+LAFaWELyiJc+ou+N8v_7xhrwHRbBZZQF@mail.gmail.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 10:29 AM, Arnd Bergmann <arnd@arndb.de> wrote:
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
>
>        Arnd

tidspbridge iommu change are working fine all the patches and few fixes after
that are alredy sent. what breaks tidspbridge, is the unmerged
dependencies in linux omap
tree, specifically the iommu module patches and the SG patch. if the
dependencies are merged tidspbridge work perfectly I don't need to fix
anything. As the dependencies are not merge yet it is ok to revert and
once push once all the dependencies are merge. I am not familiar with
that so I don't know how much time can it take.

Regards,
Fernando.

>

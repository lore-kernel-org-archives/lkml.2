Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1HEA6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab1HEA56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:57:58 -0400
Message-ID: <4E3B3FDA.1050706@redhat.com>
Date: Thu, 04 Aug 2011 21:56:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, EDAC devel <linux-edac@vger.kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86, MCE: Use MCE decoder notifier chain
References: <1310999086-30870-1-git-send-email-bp@amd64.org> <20110802115853.GC15897@aftab>
In-Reply-To: <20110802115853.GC15897@aftab>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

Em 02-08-2011 08:58, Borislav Petkov escreveu:
> Ping?
> 
> Mauro, any progress on those below?

Sorry for taking a long time on that. I'm testing it right now, together with
a few other patches for i7core.

I've added it (with a few conflict fixes) at:
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/edac.git  linux_next

If everything works as before, I'll send it to Linus tomorrow, assuming that
linux-next will catch them.

Thanks,
Mauro

> 
> Thanks.
> 
> On Mon, Jul 18, 2011 at 10:24:44AM -0400, Borislav Petkov wrote:
>> From: Borislav Petkov <borislav.petkov@amd.com>
>>
>> Hi Mauro, Tony,
>>
>> the following two patches convert i7core_edac to use the MCE decoder
>> notifier chain, thus getting rid of the custom edac_mce hook. There
>> should be no functionality change following from this along with a nice
>> diffstat of removing ca 100 lines.
>>
>> The patches are ontop of the latest tip/ras/core and are available at
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git fix-mce-logging
>>
>> I'd like to ask you guys to please give them a run to make sure I
>> haven't broken i7core_edac.
>>
>> Thanks.
>>
>>  arch/x86/kernel/cpu/mcheck/mce.c |   18 ++++-------
>>  drivers/edac/Kconfig             |    3 --
>>  drivers/edac/Makefile            |    1 -
>>  drivers/edac/edac_mce.c          |   61 --------------------------------------
>>  drivers/edac/i7core_edac.c       |   51 +++++++++++++++----------------
>>  include/linux/edac_mce.h         |   31 -------------------
>>  6 files changed, 31 insertions(+), 134 deletions(-)
>>
>>
>>
> 


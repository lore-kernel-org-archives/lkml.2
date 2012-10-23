Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab2JWTFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:05:41 -0400
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:49793
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab2JWTFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:05:40 -0400
Date: Tue, 23 Oct 2012 21:05:34 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1216253974.20121023210534@eikelenboom.it>
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-linus-3.7-rc2-tag for v3.7-rc2
In-Reply-To: <468189240.20121023193753@eikelenboom.it>
References: <20121023162707.GA16634@phenom.dumpdata.com> <468189240.20121023193753@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tuesday, October 23, 2012, 7:37:53 PM, you wrote:

> Hi Konrad,

> Did you push the tag ?
> It doesn't seem to be in your git repo.

Ah nevermind, it's there now. Sorry for the noise.


> --
> Sander

> Tuesday, October 23, 2012, 6:27:07 PM, you wrote:

>> Hey Linus,

>> Please git pull the following tag:

>>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.7-rc2-tag

>> which has bug-fixes. Most of them are just code cleanup to make x86 and ARM code
>> work in unison. There is one serious bug-fix which manifested itself in some
>> applications mysteriously getting SIGKILL. Besides that nothing earth-shattering.

>> <copied from the signed tag>:
>>  * Fix mysterious SIGSEGV or SIGKILL in applications due to corrupting
>>    of the %eip when returning from a signal handler.
>>  * Fix various ARM compile issues after the merge fallout.
>>  * Continue on making more of the Xen generic code usable by ARM platform.
>>  * Fix SR-IOV passthrough to mirror multifunction PCI devices.
>>  * Fix various compile warnings.
>>  * Remove hypercalls that don't exist anymore.
>> </copy from signed tag>

>>  arch/arm/include/asm/xen/interface.h |   12 +++++++++---
>>  arch/arm/include/asm/xen/page.h      |   13 ++++++++++---
>>  arch/arm/xen/grant-table.c           |    2 +-
>>  arch/x86/include/asm/xen/interface.h |    4 ++--
>>  arch/x86/kernel/entry_32.S           |    8 +++++---
>>  arch/x86/kernel/entry_64.S           |    2 +-
>>  arch/x86/xen/enlighten.c             |    2 --
>>  drivers/xen/balloon.c                |    3 +--
>>  drivers/xen/dbgp.c                   |    2 ++
>>  drivers/xen/events.c                 |    4 ++++
>>  drivers/xen/grant-table.c            |    8 ++++----
>>  drivers/xen/sys-hypervisor.c         |    4 +++-
>>  drivers/xen/xen-pciback/vpci.c       |   14 ++++++++++----
>>  drivers/xen/xenbus/xenbus_xs.c       |    2 ++
>>  include/xen/grant_table.h            |    2 +-
>>  include/xen/interface/grant_table.h  |    2 +-
>>  include/xen/interface/memory.h       |   24 ++----------------------
>>  17 files changed, 58 insertions(+), 50 deletions(-)

>> David Vrabel (1):
>>       xen/x86: don't corrupt %eip when returning from a signal handler

>> Ian Campbell (11):
>>       xen: xenbus: quirk uses x86 specific cpuid
>>       xen: sysfs: include err.h for PTR_ERR etc
>>       xen: sysfs: fix build warning.
>>       xen: XENMEM_translate_gpfn_list was remove ages ago and is unused.
>>       xen: events: pirq_check_eoi_map is X86 specific
>>       xen: grant: use xen_pfn_t type for frame_list.
>>       xen: balloon: don't include e820.h
>>       xen: arm: make p2m operations NOPs
>>       xen: balloon: use correct type for frame_list
>>       xen: arm: comment on why 64-bit xen_pfn_t is safe even on 32 bit
>>       xen: dbgp: Fix warning when CONFIG_PCI is not enabled.

>> Konrad Rzeszutek Wilk (1):
>>       xen/xenbus: Fix compile warning.

>> Laszlo Ersek (1):
>>       xen PV passthru: assign SR-IOV virtual functions to separate virtual slots

>> Wei Yongjun (1):
>>       xen/x86: remove duplicated include from enlighten.c






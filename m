Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0LAWSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 17:18:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58277 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0LAWSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 17:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l51806V2povQeahN1WkKgr80WrzM5ygcTK3/Kxd3gqgmvaT7RuTm/LW7gK8d7bE4Mb
         lPt3JjhRIf/MRBgoYRdTH19SNbtXT+aUpQIdoTpgaR2wZuIcqul3WzLJZ7XiVBQ1nAvc
         b5pc2kBHaeq26xxCLfRTnRAunHRFrYbVmzgOA=
MIME-Version: 1.0
In-Reply-To: <20101201122318.5af8ef6f.randy.dunlap@oracle.com>
References: <20101201133354.a7c198b1.sfr@canb.auug.org.au>
	<AANLkTimt-Td_Fv3xb8xF8NVg5NtZ2zkuUfNZrd9+BDrh@mail.gmail.com>
	<20101201122318.5af8ef6f.randy.dunlap@oracle.com>
Date: Wed, 1 Dec 2010 23:18:21 +0100
Message-ID: <AANLkTikB5aHZRL9hJT-ODqUEbiCtQN3W-vk8OUOCkzNb@mail.gmail.com>
Subject: Re: linux-next: Tree for December 1
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/1 Randy Dunlap <randy.dunlap@oracle.com>:
> On Wed, 1 Dec 2010 17:04:38 +0100 Zimny Lech wrote:
>
>> Ave
>>
>> 2010/12/1 Stephen Rothwell <sfr@canb.auug.org.au>:
>> > Hi all,
>> >
>> > Changes since 20101130:
>> >
>>
>> I remember, I reported something similar a week or two ago
>>
>>   GEN     /home/test/linux-2.6-obj/Makefile
>> scripts/kconfig/conf --silentoldconfig Kconfig
>> .config:167:warning: override: SLOB changes choice state
>> warning: (IA32_EMULATION && X86_64) selects COMPAT_BINFMT_ELF which
>> has unmet direct dependencies (COMPAT && BINFMT_ELF)
>> warning: (MTD_NAND && MTD || MTD_DOC2000 && MTD || MTD_DOC2001 && MTD
>> || MTD_DOC2001PLUS && MTD) selects MTD_NAND_IDS which has unmet direct
>> dependencies (MTD
>> warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO
>> && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL
>> which has unmet dire
>> *
>> * Restart config...
>> *
>> *
>> * Kernel hacking
>> *
>> Enable __deprecated logic (ENABLE_WARN_DEPRECATED) [Y/n/?] y
>> Enable __must_check logic (ENABLE_MUST_CHECK) [N/y/?] n
>> Warn for stack frames larger than (needs gcc 4.4) (FRAME_WARN) [2048] 2048
>> Magic SysRq key (MAGIC_SYSRQ) [N/y/?] n
>> Strip assembler-generated symbols during link (STRIP_ASM_SYMS) [N/y/?] n
>> Enable unused/obsolete exported symbols (UNUSED_SYMBOLS) [Y/n/?] y
>> Debug Filesystem (DEBUG_FS) [Y/?] y
>> Run 'make headers_check' when building vmlinux (HEADERS_CHECK) [N/y/?] n
>> Kernel debugging (DEBUG_KERNEL) [Y/n/?] y
>>   Debug shared IRQ handlers (DEBUG_SHIRQ) [N/y/?] n
>>   Detect Hard and Soft Lockups (LOCKUP_DETECTOR) [Y/n/?] y
>> Panic (Reboot) On Soft Lockups (BOOTPARAM_SOFTLOCKUP_PANIC) [Y/n/?] y
>> Detect Hung Tasks (DETECT_HUNG_TASK) [N/y/?] n
>> Debug object operations (DEBUG_OBJECTS) [N/y/?] n
>> RT Mutex debugging, deadlock detection (DEBUG_RT_MUTEXES) [Y/n/?] y
>> Built-in scriptable tester for rt-mutexes (RT_MUTEX_TESTER) [Y/n/?] y
>> Spinlock and rw-lock debugging: basic checks (DEBUG_SPINLOCK) [Y/?] y
>> Mutex debugging: basic checks (DEBUG_MUTEXES) [Y/?] y
>> Lock debugging: detect incorrect freeing of live locks
>> (DEBUG_LOCK_ALLOC) [Y/?] y
>> Lock debugging: prove locking correctness (PROVE_LOCKING) [Y/n/?] y
>>   RCU debugging: prove RCU correctness (PROVE_RCU) [Y/n/?] y
>>     RCU debugging: don't disable PROVE_RCU on first splat
>> (PROVE_RCU_REPEATEDLY) [N/y/?] n
>> RCU debugging: sparse-based checks for pointer usage
>> (SPARSE_RCU_POINTER) [Y/n/?] y
>> Lock usage statistics (LOCK_STAT) [N/y/?] n
>> Lock dependency engine debugging (DEBUG_LOCKDEP) [Y/n/?] y
>> Spinlock debugging: sleep-inside-spinlock checking
>> (DEBUG_SPINLOCK_SLEEP) [Y/n/?] y
>> Locking API boot-time self-tests (DEBUG_LOCKING_API_SELFTESTS) [N/y/?] n
>> kobject debugging (DEBUG_KOBJECT) [N/y/?] n
>> Compile the kernel with debug info (DEBUG_INFO) [N/y/?] n
>> Debug VM (DEBUG_VM) [Y/n/?] y
>> Debug VM translations (DEBUG_VIRTUAL) [Y/n/?] y
>> Debug filesystem writers count (DEBUG_WRITECOUNT) [N/y/?] n
>> Debug memory initialisation (DEBUG_MEMORY_INIT) [Y/n/?] y
>> Debug linked list manipulation (DEBUG_LIST) [Y/n/?] y
>> Linked list sorting test (TEST_LIST_SORT) [N/y/?] n
>> Debug SG table operations (DEBUG_SG) [N/y/?] n
>> Debug notifier call chains (DEBUG_NOTIFIERS) [N/y/?] n
>> Debug credential management (DEBUG_CREDENTIALS) [Y/n/?] y
>> Compile the kernel with frame pointers (FRAME_POINTER) [Y/?] y
>> torture tests for RCU (RCU_TORTURE_TEST) [N/y/?] n
>> Check for stalled CPUs delaying RCU grace periods
>> (RCU_CPU_STALL_DETECTOR) [Y/n/?] y
>>   RCU CPU stall timeout in seconds (RCU_CPU_STALL_TIMEOUT) [60] 60
>>   RCU CPU stall checking starts automatically at boot
>> (RCU_CPU_STALL_DETECTOR_RUNNABLE) [Y/n/?] y
>> Self test for the backtrace code (BACKTRACE_SELF_TEST) [Y/n/?] y
>> Force extended block device numbers and spread them
>> (DEBUG_BLOCK_EXT_DEVT) [N/y/?] n
>> Force weak per-cpu definitions (DEBUG_FORCE_WEAK_PER_CPU) [N/y/?] n
>> Linux Kernel Dump Test Tool Module (LKDTM) [N/y/?] n
>> CPU notifier error injection module (CPU_NOTIFIER_ERROR_INJECT) [Y/n/?] y
>> Fault-injection framework (FAULT_INJECTION) [Y/n/?] y
>>   Fault-injection capabilitiy for alloc_pages() (FAIL_PAGE_ALLOC) [N/y/?] n
>>   Fault-injection capability for disk IO (FAIL_MAKE_REQUEST) [Y/n/?] y
>>   Fault-injection capability for faking disk interrupts
>> (FAIL_IO_TIMEOUT) [Y/n/?] y
>>   Debugfs entries for fault-injection capabilities
>> (FAULT_INJECTION_DEBUG_FS) [N/y/?] n
>> Debug page memory allocations (DEBUG_PAGEALLOC) [N/y/?] (NEW) aborted!
>>
>> Console input/output is redirected. Run 'make oldconfig' to update
>> configuration.
>>
>> make[3]: *** [silentoldconfig] Error 1
>> make[2]: *** [silentoldconfig] Error 2
>> make[1]: *** No rule to make target `include/config/auto.conf', needed
>> by `include/config/kernel.release'.  Stop.
>> make: *** [sub-make] Error 2
>
>
> This is a problem.  Any idea how you achieved this?

Believe if I say that it was generated by make randconfig? Or this is
so amazing that you would not believe? :)

This build was done (as always) by my build script - the same that I
send you once.

It's simple:
make mrproper
make O=../dir mrproper
and in loop:
make randconfig
make

This bug appeared on third run through the loop.

>
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_SLOB=y
>
> These are part of a choice and should be mutually exclusive.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>



-- 
Slawa!
Zimny "Spie dziadu!" Lech z Wawelu

That is not dead which can eternal lie.
And with strange aeons even death may die.

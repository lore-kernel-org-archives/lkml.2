Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0HaAyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:54:17 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:45114 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755901Ab0HaAyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:54:16 -0400
Date: Mon, 30 Aug 2010 20:53:35 -0400 (EDT)
From: caiqian@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <2044609874.1606211283216015254.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <71887879.1606161283215975799.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: kdump regression compared to v2.6.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Tejun Heo" <tj@kernel.org> wrote:

> Please try this one instead.  Thanks.
Unable to reproduce it any more after applied the patch,

NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
XXX kintegrityd: rescuer dispatching to cpu0
XXX kintegrityd: rescuer done binding, bound=1
XXX kintegrityd: rescuer dispatching to cpu5
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu6
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu10
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu13
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu14
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu18
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu21
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu22
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu30
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu32
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu33
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu34
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu35
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu37
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu42
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu45
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu46
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu48
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu50
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu53
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu54
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu57
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu58
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu60
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu61
XXX kintegrityd: rescuer done binding, bound=0
XXX kintegrityd: rescuer dispatching to cpu62
XXX kintegrityd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu0
XXX kblockd: rescuer done binding, bound=1
XXX kblockd: rescuer dispatching to cpu5
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu6
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu10
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu13
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu14
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu18
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu21
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu22
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu30
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu32
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu33
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu34
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu35
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu37
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu40
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu41
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu45
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu46
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu50
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu51
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu53
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu54
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu56
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu61
XXX kblockd: rescuer done binding, bound=0
XXX kblockd: rescuer dispatching to cpu62
XXX kblockd: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu0
XXX kacpid: rescuer done binding, bound=1
XXX kacpid: rescuer dispatching to cpu5
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu6
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu10
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu13
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu14
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu18
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu21
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu22
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu30
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu32
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu33
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu34
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu35
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu37
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu40
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu41
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu45
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu46
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu50
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu51
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu53
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu54
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu56
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu61
XXX kacpid: rescuer done binding, bound=0
XXX kacpid: rescuer dispatching to cpu62
XXX kacpid: rescuer done binding, bound=0
ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20100702/dsopcode-597)
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_._OSC] (Node ffff880c6e58cf38), AE_AML_BUFFER_LIMIT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [IOH0] (domain 0000 [bus 00-7f])
...

> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index a2dccfc..75cdbc2 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1224,6 +1224,8 @@ __acquires(&gcwq->lock)
>  {
>  	struct global_cwq *gcwq = worker->gcwq;
>  	struct task_struct *task = worker->task;
> +	static unsigned int cnt;
> +	int rc;
> 
>  	while (true) {
>  		/*
> @@ -1232,8 +1234,11 @@ __acquires(&gcwq->lock)
>  		 * it races with cpu hotunplug operation.  Verify
>  		 * against GCWQ_DISASSOCIATED.
>  		 */
> -		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
> -			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
> +		if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
> +			rc = set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
> +			if (rc && ++cnt < 10)
> +				printk("XXX set_cpus_allowed_ptr() failed w/ %d\n", rc);
> +		}
> 
>  		spin_lock_irq(&gcwq->lock);
>  		if (gcwq->flags & GCWQ_DISASSOCIATED)
> @@ -1985,13 +1990,16 @@ repeat:
>  		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
>  		struct global_cwq *gcwq = cwq->gcwq;
>  		struct work_struct *work, *n;
> +		bool bound;
> 
>  		__set_current_state(TASK_RUNNING);
>  		mayday_clear_cpu(cpu, wq->mayday_mask);
> 
>  		/* migrate to the target cpu if possible */
>  		rescuer->gcwq = gcwq;
> -		worker_maybe_bind_and_lock(rescuer);
> +		printk("XXX %s: rescuer dispatching to cpu%u\n", wq->name,
> gcwq->cpu);
> +		bound = worker_maybe_bind_and_lock(rescuer);
> +		printk("XXX %s: rescuer done binding, bound=%d\n", wq->name,
> bound);
> 
>  		/*
>  		 * Slurp in all works issued via this workqueue and
> @@ -3558,8 +3566,7 @@ static int __init init_workqueues(void)
>  		spin_lock_init(&gcwq->lock);
>  		INIT_LIST_HEAD(&gcwq->worklist);
>  		gcwq->cpu = cpu;
> -		if (cpu == WORK_CPU_UNBOUND)
> -			gcwq->flags |= GCWQ_DISASSOCIATED;
> +		gcwq->flags |= GCWQ_DISASSOCIATED;
> 
>  		INIT_LIST_HEAD(&gcwq->idle_list);
>  		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
> @@ -3583,6 +3590,8 @@ static int __init init_workqueues(void)
>  		struct global_cwq *gcwq = get_gcwq(cpu);
>  		struct worker *worker;
> 
> +		if (cpu != WORK_CPU_UNBOUND)
> +			gcwq->flags &= ~GCWQ_DISASSOCIATED;
>  		worker = create_worker(gcwq, true);
>  		BUG_ON(!worker);
>  		spin_lock_irq(&gcwq->lock);
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

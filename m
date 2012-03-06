Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837Ab2CFOu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:50:59 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50723 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030787Ab2CFOu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:50:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eag0628@gmail.com designates 10.229.69.70 as permitted sender) smtp.mail=eag0628@gmail.com; dkim=pass header.i=eag0628@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331033947.11248.283.camel@twins>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	<1331033947.11248.283.camel@twins>
Date: Tue, 6 Mar 2012 22:50:56 +0800
Message-ID: <CACvQF50+Aafho4OLU8o+ybE3eVcXHQkti4tzu3N+c5XUd5zL+g@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
From: Lai Jiangshan <eag0628@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 7:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
>> +       int cpu = get_cpu();
>> +       struct srcu_cpu_struct *scp = per_cpu_ptr(sp->srcu_per_cpu, cpu)
>
> They invented get_cpu_ptr() for that..

Thanks.
And I'm sorry, these code is merged by two functions,
I forgot it when merging, I need to check it more.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

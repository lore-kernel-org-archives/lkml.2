Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab2GYOZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:25:22 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55003 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab2GYOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120716103749.122800930@linutronix.de>
References: <20120716103749.122800930@linutronix.de>
Date: Wed, 25 Jul 2012 23:25:19 +0900
Message-ID: <CAAmzW4OPOCeotTesZy14vSxP+g1=D+KAeaLJQJKdJZqTpKTTgw@mail.gmail.com>
Subject: Re: [Patch 0/7] Per cpu thread hotplug infrastructure - V3
From: JoonSoo Kim <js1304@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/16 Thomas Gleixner <tglx@linutronix.de>:
> The following series implements the infrastructure for parking and
> unparking kernel threads to avoid the full teardown and fork on cpu
> hotplug operations along with management infrastructure for hotplug
> and users.
>
> Changes vs. V2:
>
>  Use callbacks for all functionality. Thanks to Rusty for pointing
>  that out. It makes the use sites nice and simple and keeps all the
>  code which would be duplicated otherwise on the core.
>
> Thanks,
>
>         tglx
>

I'm just a kernel newbie, so I have a dumb question.
Why this patchset doesn't include patch for migrationd in kernel/stop_machine.c?
Is there any reason for that?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2EHPQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:16:12 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:45843 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755943Ab2EHPQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:16:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: abtwyOkVM1meKS76skPvhBi3yl9ZdpVfZsuQIfCtrIPeZeU
 2IocKqSxPyL92nvYIwrp9aN_RFXObYmuvgJqGrx1c8.23330LNZ3wk1RIQDe
 iek7JyDY8yYBV2AFeBLed4b.IoAAdgS4mBFYpnX2IGlN5Y.Z2CK0a2jmYxjY
 XCAUrBmW7vqCyqLqusLUnCoDrYwe2pDbTkg4i.DLhtm53MgLXgBCLo0ZP.12
 JtDuyGuHoDzNATigv6UnyKFOPU4lh6b9YpYIBaZ26Xen30F_1xFlZL8N7SF0
 l.x3InJ21Y77nBPQkJy8gEEM3zxV34rHTrZ_2SsWk8OhpZdwXKsn7W8e_54p
 ABz0MrPcQ3YPd4ed3ALJQVkrP4AEjjlWu9QvuRahgYCvgoYPWBAfRVzPn2fT
 i
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 10:16:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
In-Reply-To: <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205081014480.27713@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-879625646-1336490169=:27713"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-879625646-1336490169=:27713
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 8 May 2012, Frederic Weisbecker wrote:

> > As I have said before: It would be much simpler if one could specify th=
e
> > set of nohz cpus independently of cpusets. Having a flag f.e. as a file=
 in
> >
> > =A0 =A0 =A0 =A0/sys/devices/system/cpu/cpuX/nohz
>
> I don't know if it would be simpler. It's just a different interface
> to set a per-CPU property.
> Cpusets of sysfs, I don't mind either way.
>
> What is the usual policy on where to put which kind of CPU property?

/sys/devices/system/cpu contains the state information for each processor.

There are already cpumasks in there that can be used to monitor and modify
per processor behavior.

---1463811839-879625646-1336490169=:27713--

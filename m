Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab2CUOui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:50:38 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:20652 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031319Ab2CUOuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:50:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0QS97zsVM1l6S7ZXmoQbYngXvyebXRxwKi8_L8Z8GnnWKEH
 Z1y8cqkpTLZ_.rUdaSZ0kOem.Y5jQsuOez_dPLeAn9NlxqOQb0cCaEr9wMT1
 T_KKGPaGkgQqgPkWXkTPgNjxb3V7sUphkMO95BZkX247AKA.B8lQsHMKs8Os
 PwCFDu20B8ZgmzeTCyt6RkxY6xIbHHW4jI3aEDHO6_7IFAN6vqIZ46soRM2L
 MD2yel780AGWHBY1cf.sh23Yg41HUjDLiqNIA7u6ncIHbUjJdjGaHjFwmOEn
 PGsIkeniRcF2saYDOAbPGWXJ9Pk4IRbleT4vZ5FLYBReaZBX1iRdaYE0JZjU
 vPtGW4i_opY1EMUXO9uG.Ml4EklZnJGEVsbpnIfE8tH21.6Z_ufxmsc1MFbB
 _
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 09:50:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 07/32] cpuset: Set up interface for nohz flag
In-Reply-To: <1332338318-5958-9-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.1203210949440.20482@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-9-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Frederic Weisbecker wrote:

> Prepare the interface to implement the nohz cpuset flag.
> This flag, once set, will tell the system to try to
> shutdown the periodic timer tick when possible.
>
> We use here a per cpu refcounter. As long as a CPU
> is contained into at least one cpuset that has the
> nohz flag set, it is part of the set of CPUs that
> run into adaptive nohz mode.

What are the drawbacks for nohz?

If there are none: Can we make nohz default behavior without relying on
cpusets?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab2EHPiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:38:15 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:22880 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755510Ab2EHPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:38:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yTlYTLYVM1ktVV.xdS5E6MZhR8rFmLIeUKJlXVhpT.XPCfa
 j7T9zrLuwFmCee4ES1eTwFykHo7CWRNw79PXUeXwWlE3ZbGKusYxnOK3sjOV
 l9QoeJ547cDfn9ZjTReCiZaRUysCuBoyZeXKLQADwOCVWYwe_6ooGSjHKsds
 DhSppVAYnskN_CPT5cPGQogcp9Pzfs84nogtTGtWSCbt93gyNurJS_RRl_hs
 BbGY6KfSZhNZNSFAJTuZi4CIWik9Sy_0M.KIk51kQ9OTT8y1l.2NGiEo_a8O
 AadgZdOYvaKmhHW43qBjSM.lRDKNnbYJL96XyLGou09NK9Wkr9z.xxy.v3RE
 H0clF8r88GXnynFSTCJcFJ7Ve0G4nRFtCyRm1IqXWHPOfnmczF7zRemjdUmw
 m
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 10:38:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
In-Reply-To: <1336490832.8226.5.camel@twins>
Message-ID: <alpine.DEB.2.00.1205081035550.27713@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins> <alpine.DEB.2.00.1205081016370.27713@router.home> <1336490832.8226.5.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Peter Zijlstra wrote:

> isolating how? The only way to do that is with the (broken) isolcpus
> crap and cpusets. There is no other way.

For some reason this seems to work here. What is broken with isolcpus?

> Furthermore there is no other partitioning scheme, cpusets is it.

One can partition the system anyway one wants by setting cpu affinities
and memory policies etc. No need for cpusets/cgroups.


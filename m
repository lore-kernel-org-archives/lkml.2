Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2F1QCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:02:06 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38409 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2F1QCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:02:02 -0400
Date: Thu, 28 Jun 2012 12:00:46 -0400 (EDT)
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, chegu vinod <chegu_vinod@hp.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
Message-ID: <168f205d-d65f-4864-99c8-363b12818a9b@zmail17.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4FEB6CAC.1020406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [70.43.169.206]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Win)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> In summary, current PV has huge benefit on non-PLE machine.
> 
> On PLE machine, the results become very sensitive to load, type of
> workload and SPIN_THRESHOLD. Also PLE interference has significant
> effect on them. But still it has slight edge over non PV.
> 

Hi Raghu,

sorry for my slow response. I'm on vacation right now (until the
9th of July) and I have limited access to mail. Also, thanks for
continuing the benchmarking. Question, when you compare PLE vs.
non-PLE, are you using different machines (one with and one
without), or are you disabling its use by loading the kvm module
with the ple_gap=0 modparam as I did?

Drew

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2F2O5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:57:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab2F2O47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:56:59 -0400
Message-ID: <4FEDC22F.9070406@redhat.com>
Date: Fri, 29 Jun 2012 17:56:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: jan.kiszka@siemens.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <4FEC8D31.3070406@redhat.com> <4FEC93BD.2070809@siemens.com> <4FEC95BC.200@redhat.com> <4FED7495.30707@hitachi.com>
In-Reply-To: <4FED7495.30707@hitachi.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 12:25 PM, Tomoki Sekiyama wrote:
> Hi, thanks for your comments.
>
> On 2012/06/29 2:34, Avi Kivity wrote:
> > On 06/28/2012 08:26 PM, Jan Kiszka wrote:
> >>> This is both impressive and scary.  What is the target scenario here?
> >>> Partitioning?  I don't see this working for generic consolidation.
> >>
> >> From my POV, partitioning - including hard realtime partitions - would
> >> provide some use cases. But, as far as I saw, there are still major
> >> restrictions in this approach, e.g. that you can't return to userspace
> >> on the slave core. Or even execute the in-kernel device models on that core.
>
> Exactly this is for partitioning that requires bare-metal performance
> with low latency and realtime.

It's hard for me to evaluate how large that segment is.  Since the
patchset is so intrusive, it needs a large potential user set to
justify, or a large reduction in complexity, or both.

>  I think it is also useful for workload
> like HPC with MPI, that is CPU intensive and that needs low latency.

I keep hearing about people virtualizing these types of workloads, but I
haven't yet understood why.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


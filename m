Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0EFHas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:30:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:40942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab0EFHar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:30:47 -0400
Message-ID: <4BE26FEC.6010706@kernel.org>
Date: Thu, 06 May 2010 09:29:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org> <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org> <20100505165532.GC14323@elte.hu> <1273083173.1642.250.camel@laptop> <20100506063116.GE1172@elte.hu> <1273129464.5605.228.camel@twins> <20100506071153.GA3626@elte.hu>
In-Reply-To: <20100506071153.GA3626@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 07:29:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/06/2010 09:11 AM, Ingo Molnar wrote:
> That said, i agree with you that turning the basic perf scheduling
> calls into events goes one step too far.

But if you put all those calls on top of TPs and apply static
optimization to TPs (yeah, that can be applied directly to perf calls
too but it's simpler to consolidate, IMHO), perf becomes zero-cost
when disabled.

Thanks.

-- 
tejun

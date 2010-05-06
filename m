Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0EFHeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:34:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:49605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab0EFHeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:34:08 -0400
Message-ID: <4BE270D8.5060507@kernel.org>
Date: Thu, 06 May 2010 09:33:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org> <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org> <20100505165532.GC14323@elte.hu> <1273083173.1642.250.camel@laptop> <20100506063116.GE1172@elte.hu> <1273129464.5605.228.camel@twins> <20100506071153.GA3626@elte.hu> <4BE26FEC.6010706@kernel.org>
In-Reply-To: <4BE26FEC.6010706@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 07:33:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 09:29 AM, Tejun Heo wrote:
> (yeah, that can be applied directly to perf calls too but it's
> simpler to consolidate, IMHO)

Oh, also, if static text optimization is applied to perf calls
directly, it would require about the same complexity overhead as doing
it on top of TPs.  It would still have to drain contexts before
turning off those hooks, so the only advantage is the ability to build
the kernel w/ PERF but w/o TPs.

Thanks.

-- 
tejun

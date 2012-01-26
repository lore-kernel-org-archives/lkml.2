Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab2AZMOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 07:14:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59544 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2AZMOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 07:14:42 -0500
Message-ID: <4F214380.2040601@kernel.dk>
Date: Thu, 26 Jan 2012 13:13:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs tunable
References: <20120116161740.29759.4679.stgit@localhost>    <20120116162241.29759.13220.stgit@localhost>   <1327503181.2614.76.camel@laptop> <4F212DFF.8060802@kernel.dk>  <1327576091.2446.87.camel@twins> <4F21386C.5000809@kernel.dk> <1327579450.2446.95.camel@twins>
In-Reply-To: <1327579450.2446.95.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 01:04 PM, Peter Zijlstra wrote:
> On Thu, 2012-01-26 at 12:26 +0100, Jens Axboe wrote:
>> O
>> Yeah, I think that would suit my purpose nicely, in fact. What level of
>> cache sharing is being used here? The block code wanted a per-socket
>> type operation, but since it's a heuristic, perhaps the above is even
>> better (or equivelant, perhaps).
> 
> It uses the biggest shared cache exposed in the topology information the
> scheduler has (which is currently somewhat funny but is on the todo list
> for improvements).
> 
> Effectively it ends up being the socket wide LLC for modern Intel chips
> though.
> 
> Would something like the below work for you (compile tested only).

Yep, looks good to me, and an improvement for me not to carry this code
that doesn't really belong there.

-- 
Jens Axboe


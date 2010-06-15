Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0FOToG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:44:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47850 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab0FOToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:44:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6014"; a="44395267"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C17C598.7070303@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 12:43:57 -0700
Message-ID: <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 20:25 +0200, Tejun Heo wrote:
> Hello, all.
> 
> So, here's the overview I wrote up today.  If anything needs more
> clarification, just ask.  Thanks.
> 
> == Overview
> 
> There are many cases where an execution context is needed and there
> already are several mechanisms for them.  The most commonly used one
> is workqueue and there are slow_work, async and a few other.  Although
> workqueue has been serving the kernel for quite some time now, it has
> some limitations.

I noticed that you removed the RT workqueue since it's no longer used,
but it's possible that a user can raise the priority of a given work
queue thread into real time priorities. So with single threaded, and
multithreaded workqueues specific to certain areas of the kernel the
user would have a greater ability to control priorities of those areas.

It looks like with your patches it would remove that level of
flexability effectively making all the work item the same priority with
no ability to raise or lower .. Is that accurate ?

btw, Thanks for the write up.

Daniel


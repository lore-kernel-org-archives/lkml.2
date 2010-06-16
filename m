Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab0FPNlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:41:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3676 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab0FPNlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:41:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6014"; a="44469324"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C18D1FD.9060804@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 06:41:04 -0700
Message-ID: <1276695665.9309.17.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 15:30 +0200, Tejun Heo wrote:
> On 06/16/2010 03:27 PM, Daniel Walker wrote:
> >> Yes, that is.  With new cmwq, a wq can't assume association with
> >> specific kthread and thus can't use wq as simple frontend to kthreads,
> >> but if somebody wants dedicated kthreads instead of shared ones in
> >> units of work, [s]he should be using kthread.
> > 
> > I'm not talking about coders using workqueues when they should be using
> > kthreads .. We're talking about currently existing workqueues. Aren't
> > you converting all _current_ workqueues to your system?
> 
> Yes, sure I'm but which current users are you talking about?

Any workqueue that has a thread which can be prioritized from userspace.
As long as there is a thread it can usually be given a priority from
userspace, so any _current_ workqueue which uses a single thread or
multiple threads is an example of what I'm talking about.

Daniel


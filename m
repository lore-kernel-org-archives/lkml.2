Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab0FPSlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:41:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49312 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0FPSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:41:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6015"; a="44637644"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C191885.9080303@s5r6.in-berlin.de>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C191885.9080303@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 11:41:04 -0700
Message-ID: <1276713664.9309.177.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 20:31 +0200, Stefan Richter wrote:
> Daniel Walker wrote:
> [tweak scheduling priority of a worker thread]
> > Let say I have a high priority
> > thread in userspace , and I discover through analysis that my thread is
> > being forced to wait on a workqueue thread (priority inversion) , so
> > then I just increase the workqueue thread priority to overcome the
> > inversion. That's totally valid, and you don't even need to know exactly
> > what the thread is doing..
> 
> I suspect the _actual_ problem to solve here is not that of proper
> scheduling priorities but that of having to meet deadlines.

I think the workqueue would need to be adjust somehow even in terms of
deadlines. Like you'll miss your deadline unless the workqueue runs.

Daniel


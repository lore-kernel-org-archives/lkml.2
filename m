Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0FPSc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:32:28 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45151 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0FPSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:32:26 -0400
Message-ID: <4C191885.9080303@s5r6.in-berlin.de>
Date: Wed, 16 Jun 2010 20:31:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.24) Gecko/20100228 SeaMonkey/1.1.19
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
In-Reply-To: <1276698880.9309.44.camel@m0nster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
[tweak scheduling priority of a worker thread]
> Let say I have a high priority
> thread in userspace , and I discover through analysis that my thread is
> being forced to wait on a workqueue thread (priority inversion) , so
> then I just increase the workqueue thread priority to overcome the
> inversion. That's totally valid, and you don't even need to know exactly
> what the thread is doing..

I suspect the _actual_ problem to solve here is not that of proper
scheduling priorities but that of having to meet deadlines.
-- 
Stefan Richter
-=====-==-=- -==- =----
http://arcgraph.de/sr/

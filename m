Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab0FNWtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:49:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54248 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0FNWtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:49:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6013"; a="44443175"
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C16B0CA.9060107@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <20100614145839.8ac7687a.akpm@linux-foundation.org>
	 <4C16AA75.8030303@kernel.org>
	 <1276554672.3505.199.camel@c-dwalke-linux.qualcomm.com>
	 <4C16AE4B.609@kernel.org>
	 <1276554931.3505.200.camel@c-dwalke-linux.qualcomm.com>
	 <4C16B0CA.9060107@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 15:49:12 -0700
Message-ID: <1276555752.3505.204.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 00:44 +0200, Tejun Heo wrote:
> On 06/15/2010 12:35 AM, Daniel Walker wrote:
> > What is you definition of "concurrency" ? and explain try to explain it
> > in terms of your patchset.
> 
> How many workers are concurrently executing?  What else?  Eh... I'll
> write up another summary tomorrow.  Let's talk it there.

I'd suggest If you write up another description try to not use the word
concurrency .. That term can be used for all sorts of things, and it
doesn't covey enough detail for anyone to know what your implementation
is actually doing.

Daniel


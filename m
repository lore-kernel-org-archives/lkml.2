Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab0FNWbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:31:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57375 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0FNWbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:31:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6013"; a="44301189"
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C16AA75.8030303@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <20100614145839.8ac7687a.akpm@linux-foundation.org>
	 <4C16AA75.8030303@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 15:31:12 -0700
Message-ID: <1276554672.3505.199.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 00:17 +0200, Tejun Heo wrote:
> On 06/14/2010 11:58 PM, Andrew Morton wrote:
> > On Mon, 14 Jun 2010 23:37:17 +0200
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> This is the fifth take of cmwq (concurrency managed workqueue)
> >> patchset.
> > 
> > What is a concurrency managed workqueue and why do we want one?
> 
> That goes back about 9 month.  You were cc'd there too.  :-)
> 
>   http://thread.gmane.org/gmane.linux.kernel/896268

Could you explain how you view "concurrency" w.r.t this patchset?

Daniel


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1G2Rjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:39:53 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57058 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1G2Rjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:39:51 -0400
In-Reply-To: <CAL1RGDXJzW7e2LTyex1EZXSLBdB_xmcBvBiiS2XKL-5qUCOQ1w@mail.gmail.com>
References: <1311923731.7845.25.camel@edumazet-laptop> <CAL1RGDXJzW7e2LTyex1EZXSLBdB_xmcBvBiiS2XKL-5qUCOQ1w@mail.gmail.com>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
X-KeepSent: 31C67CA1:9901BC1C-C12578DC:0060E598;
 type=4; name=$KeepSent
To: Roland Dreier <roland@kernel.org>
Cc: Christoph Raisch <raisch@de.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org, roland@purestorage.com,
        Sean Hefty <sean.hefty@intel.com>
X-Mailer: Lotus Notes Release 8.0.2 HF623 January 16, 2009
Message-ID: <OF31C67CA1.9901BC1C-ONC12578DC.0060E598-C12578DC.006101DD@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Fri, 29 Jul 2011 19:39:33 +0200
X-MIMETrack: Serialize by Router on D12ML071/12/M/IBM(Release 8.0.2FP6|July 15, 2010) at
 29/07/2011 19:39:34
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,
This patch looks fine to me.
Thanks
Nam

roland@purestorage.com wrote on 29.07.2011 19:10:32:

> [image removed]
>
> Re: [PATCH] IB/ehca: use kthread_create_on_node
>
> Roland Dreier
>
> to:
>
> Eric Dumazet
>
> 29.07.2011 19:11
>
> Sent by:
>
> roland@purestorage.com
>
> Cc:
>
> Hoang-Nam Nguyen, Christoph Raisch, Sean Hefty, linux-rdma, linux-kernel
>
> On Fri, Jul 29, 2011 at 12:15 AM, Eric Dumazet <eric.dumazet@gmail.com>
wrote:
> > Since create_comp_task() creates percpu kthread, it makes
> > sense to use kthread_create_on_node() to get proper NUMA affinity for
> > kthread stack.
>
> Seems eminently sane to me.  ehca guys, any concern about this?
>
>  - R.


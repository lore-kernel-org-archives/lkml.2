Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1G2RKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:10:55 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:42766 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750756Ab1G2RKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <1311923731.7845.25.camel@edumazet-laptop>
References: <1311923731.7845.25.camel@edumazet-laptop>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 29 Jul 2011 10:10:32 -0700
X-Google-Sender-Auth: e7c-KEkBr8vL1eP94FA29tooiv8
Message-ID: <CAL1RGDXJzW7e2LTyex1EZXSLBdB_xmcBvBiiS2XKL-5qUCOQ1w@mail.gmail.com>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 12:15 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Since create_comp_task() creates percpu kthread, it makes
> sense to use kthread_create_on_node() to get proper NUMA affinity for
> kthread stack.

Seems eminently sane to me.  ehca guys, any concern about this?

 - R.

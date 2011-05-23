Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1EWSGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:06:25 -0400
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:39939 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756791Ab1EWSGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110523094205.4a5651d2.randy.dunlap@oracle.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523094205.4a5651d2.randy.dunlap@oracle.com>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 23 May 2011 11:05:59 -0700
Message-ID: <BANLkTindDsbE-Fdr5-Db4Kw6ww+ntk2S2Q@mail.gmail.com>
Subject: Re: linux-next: Tree for May 23 (infiniband + netlink)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 9:42 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 23 May 2011 15:45:18 +1000 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20110520:
>
> when CONFIG_NET is not enabled:
>
> ERROR: "skb_trim" [drivers/infiniband/core/ib_core.ko] undefined!
> ERROR: "netlink_kernel_create" [drivers/infiniband/core/ib_core.ko] undefined!
> ERROR: "netlink_kernel_release" [drivers/infiniband/core/ib_core.ko] undefined!
> ERROR: "netlink_rcv_skb" [drivers/infiniband/core/ib_core.ko] undefined!
> ERROR: "nla_put" [drivers/infiniband/core/ib_core.ko] undefined!
> ERROR: "init_net" [drivers/infiniband/core/ib_core.ko] undefined!
> ERROR: "netlink_dump_start" [drivers/infiniband/core/ib_core.ko] undefined!
> ERROR: "skb_put" [drivers/infiniband/core/ib_core.ko] undefined!

Guess we have to depend on CONFIG_NET now.
I'll fix it up.

Thanks,
  Roland

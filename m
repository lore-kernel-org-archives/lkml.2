Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1EWQm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:42:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26173 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1EWQmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:42:25 -0400
Date: Mon, 23 May 2011 09:42:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
Subject: Re: linux-next: Tree for May 23 (infiniband + netlink)
Message-Id: <20110523094205.4a5651d2.randy.dunlap@oracle.com>
In-Reply-To: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4DDA8E6D.014C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 15:45:18 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110520:

when CONFIG_NET is not enabled:

ERROR: "skb_trim" [drivers/infiniband/core/ib_core.ko] undefined!
ERROR: "netlink_kernel_create" [drivers/infiniband/core/ib_core.ko] undefined!
ERROR: "netlink_kernel_release" [drivers/infiniband/core/ib_core.ko] undefined!
ERROR: "netlink_rcv_skb" [drivers/infiniband/core/ib_core.ko] undefined!
ERROR: "nla_put" [drivers/infiniband/core/ib_core.ko] undefined!
ERROR: "init_net" [drivers/infiniband/core/ib_core.ko] undefined!
ERROR: "netlink_dump_start" [drivers/infiniband/core/ib_core.ko] undefined!
ERROR: "skb_put" [drivers/infiniband/core/ib_core.ko] undefined!

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

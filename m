Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab0HNCsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 22:48:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56632 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab0HNCsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 22:48:11 -0400
Date: Fri, 13 Aug 2010 19:47:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 13 (ceph)
Message-Id: <20100813194743.66738337.randy.dunlap@oracle.com>
In-Reply-To: <20100813131347.1938f349.sfr@canb.auug.org.au>
References: <20100813131347.1938f349.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 13:13:47 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> As the merge window is open, please do not add 2.6.37 material to your
> linux-next included trees until after 2.6.36-rc1.
> 
> Changes since 20100812:
> 
> The ceph tree gained a conflict against Linus' tree.

When CONFIG_NET is not enabled:

ERROR: "kernel_sendmsg" [net/ceph/libceph.ko] undefined!
ERROR: "sock_release" [net/ceph/libceph.ko] undefined!
ERROR: "sock_create_kern" [net/ceph/libceph.ko] undefined!
ERROR: "kernel_sendpage" [net/ceph/libceph.ko] undefined!
ERROR: "in4_pton" [net/ceph/libceph.ko] undefined!
ERROR: "kernel_recvmsg" [net/ceph/libceph.ko] undefined!
ERROR: "in6_pton" [net/ceph/libceph.ko] undefined!

so my earlier comment about CEPH_LIB depending on INET should take
care of this one also.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

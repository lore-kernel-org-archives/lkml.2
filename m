Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab0DGROd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:14:33 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:37501 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab0DGROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:14:31 -0400
Date: Wed, 7 Apr 2010 09:58:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 7 (net/core/dev_addr_lists)
Message-Id: <20100407095845.f29ebf48.randy.dunlap@oracle.com>
In-Reply-To: <20100407174123.81b32310.sfr@canb.auug.org.au>
References: <20100407174123.81b32310.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BBCB9F6.00F6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010 17:41:23 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100401:


when CONFIG_PROC_FS is disabled:

linux-next-20100407/net/core/dev_addr_lists.c: In function 'dev_mc_net_init':
linux-next-20100407/net/core/dev_addr_lists.c:722: error: implicit declaration of function 'proc_net_fops_create'
linux-next-20100407/net/core/dev_addr_lists.c:722: error: 'dev_mc_seq_fops' undeclared (first use in this function)
linux-next-20100407/net/core/dev_addr_lists.c:722: error: (Each undeclared identifier is reported only once
linux-next-20100407/net/core/dev_addr_lists.c:722: error: for each function it appears in.)
linux-next-20100407/net/core/dev_addr_lists.c: In function 'dev_mc_net_exit':
linux-next-20100407/net/core/dev_addr_lists.c:729: error: implicit declaration of function 'proc_net_remove'
make[3]: *** [net/core/dev_addr_lists.o] Error 1

---
~Randy

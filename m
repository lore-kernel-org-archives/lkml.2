Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2FTR2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:28:06 -0400
Received: from mail.us.es ([193.147.175.20]:33164 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab2FTR2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:28:04 -0400
Date: Wed, 20 Jun 2012 19:28:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: next-20120620 build error in netfilter
Message-ID: <20120620172801.GA9385@1984>
References: <32596.1340212473@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32596.1340212473@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 01:14:33PM -0400, Valdis Kletnieks wrote:
> Today's linux-next fails to build with CONFIG_NF_NAT_NEEDED=y and CONFIG_NF_NAT=m
> 
>   LD      init/built-in.o
> net/built-in.o:(.data+0x4408): undefined reference to `nf_nat_tcp_seq_adjust'
> make: *** [vmlinux] Error 1

I guess you have NF_CT_NETLINK=y, right?

> Breakage introduced with this commit:
> 
> commit 8c88f87cb27ad09086940bdd3e6955e5325ec89a
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Thu Jun 7 13:31:25 2012 +0200
> 
>     netfilter: nfnetlink_queue: add NAT TCP sequence adjustment if packet mangled
> 



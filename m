Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0JZFCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 01:02:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32954
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045Ab0JZFCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 01:02:53 -0400
Date: Mon, 25 Oct 2010 22:03:16 -0700 (PDT)
Message-Id: <20101025.220316.39174493.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for October 25 (netfilter/nf_conntrack_reasm)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101025165529.9cedfeac.randy.dunlap@oracle.com>
References: <20101025145834.9b68e026.sfr@canb.auug.org.au>
	<20101025165529.9cedfeac.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 25 Oct 2010 16:55:29 -0700

> On Mon, 25 Oct 2010 14:58:34 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>> 
>> Reminder: do not add 2.6.38 destined stuff to linux-next until after
>> 2.6.37-rc1 is released.
> 
> net/ipv6/netfilter/nf_conntrack_reasm.c:628: error: 'nf_ct_frag6_sysctl_header' undeclared (first use in this function)
> net/ipv6/netfilter/nf_conntrack_reasm.c:628: error: 'nf_net_netfilter_sysctl_path' undeclared (first use in this function)
> net/ipv6/netfilter/nf_conntrack_reasm.c:629: error: 'nf_ct_frag6_sysctl_table' undeclared (first use in this function)
> net/ipv6/netfilter/nf_conntrack_reasm.c:640: error: 'nf_ct_frag6_sysctl_header' undeclared (first use in this function)
> 
> 
> config file is attached.

Should also be fixed by the commit I just pointed you to.

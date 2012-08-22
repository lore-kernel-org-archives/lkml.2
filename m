Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189Ab2HVWcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:32:33 -0400
Received: from mail.us.es ([193.147.175.20]:58169 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab2HVWcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:32:31 -0400
Date: Thu, 23 Aug 2012 00:32:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, David Miller <davem@davemloft.net>,
        kaber@trash.net,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] netfilter: replace list_for_each_continue_rcu with
 new interface
Message-ID: <20120822223228.GA11141@1984>
References: <502CB939.3050008@linux.vnet.ibm.com>
 <502DC9A3.2070703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502DC9A3.2070703@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:33:39PM +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> This patch replaces list_for_each_continue_rcu() with
> list_for_each_entry_continue_rcu() to allow removing
> list_for_each_continue_rcu().

Applied, thanks.

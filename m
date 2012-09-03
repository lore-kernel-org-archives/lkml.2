Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2ICPbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:31:46 -0400
Received: from mail.us.es ([193.147.175.20]:56343 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab2ICPbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:31:45 -0400
Date: Mon, 3 Sep 2012 17:31:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        coreteam@netfilter.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org, David Miller <davem@davemloft.net>,
        kaber@trash.net
Subject: Re: [PATCH 1/2] netfilter: pass 'nf_hook_ops' instead of
 'list_head' to nf_iterate()
Message-ID: <20120903153142.GB19926@1984>
References: <5035C6DD.3000600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5035C6DD.3000600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 01:59:57PM +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> Since 'list_for_each_continue_rcu' has already been replaced by
> 'list_for_each_entry_continue_rcu', pass 'list_head' to nf_iterate() as a
> parameter can not benefit us any more.
> 
> This patch will replace 'list_head' with 'nf_hook_ops' as the parameter of
> nf_iterate() to save code.

Applied, thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2APMjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:39:35 -0500
Received: from mail.us.es ([193.147.175.20]:34594 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2APMjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:39:33 -0500
Date: Mon, 16 Jan 2012 13:39:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: fix unused variable warning in
 xt_hashlimit.c
Message-ID: <20120116123925.GA13131@1984>
References: <20120111115217.b5db064c4bf233a4e1df42b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120111115217.b5db064c4bf233a4e1df42b8@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:52:17AM +1100, Stephen Rothwell wrote:
> Fixes this warning when CONFIG_IP6_NF_IPTABLES is not enabled:
> 
> net/netfilter/xt_hashlimit.c: In function ‘hashlimit_init_dst’:
> net/netfilter/xt_hashlimit.c:448:9: warning: unused variable ‘frag_off’ [-Wunused-variable]
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks.

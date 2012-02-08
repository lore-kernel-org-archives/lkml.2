Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2BHK31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:29:27 -0500
Received: from mail.us.es ([193.147.175.20]:45258 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab2BHK3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:29:25 -0500
Date: Wed, 8 Feb 2012 11:29:14 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jengelh@medozas.de, rostedt@goodmis.org
Subject: Re: [PATCH 4/4] Netfilter: xt_LOG: Implement ring buffer support
Message-ID: <20120208102914.GA32092@1984>
References: <1328400892-22409-1-git-send-email-richard@nod.at>
 <1328400892-22409-7-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328400892-22409-7-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 01:14:52AM +0100, Richard Weinberger wrote:
> This patch introduces NETFILTER_XT_TARGET_LOG_RING.
> It allows logging into various ring buffers which are
> represented as pipe-like files in /proc/net/netfilter/xt_LOG_ring/.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  include/linux/netfilter/xt_LOG.h    |   13 +-
>  include/net/netfilter/nf_log.h      |    1 +
>  include/net/netfilter/xt_log_ring.h |   24 +
>  net/netfilter/Kconfig               |   13 +
>  net/netfilter/Makefile              |    2 +
>  net/netfilter/xt_LOG.c              |  921 -----------------------------
>  net/netfilter/xt_LOG_core.c         | 1108 +++++++++++++++++++++++++++++++++++
>  net/netfilter/xt_LOG_ring.c         |  430 ++++++++++++++

Can you avoid this rename and splitting LOG into two files? I prefer
having everything into the same file xt_LOG.c.

Apart from that, this looks fine to me.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2ENIZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:25:19 -0400
Received: from mail.us.es ([193.147.175.20]:39198 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab2ENIZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:25:13 -0400
Date: Mon, 14 May 2012 10:25:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: "David S. Miller" <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter/xt_CT.c: remove redundant header include
Message-ID: <20120514082504.GC9577@1984>
References: <1336601016-19495-1-git-send-email-eldad@fogrefinery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336601016-19495-1-git-send-email-eldad@fogrefinery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:03:35AM +0200, Eldad Zack wrote:
> nf_conntrack_l4proto.h is included twice.

Applied, thanks.

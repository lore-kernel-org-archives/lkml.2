Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1INMbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 08:31:44 -0400
Received: from mail.us.es ([193.147.175.20]:52420 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab1INMbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 08:31:42 -0400
Date: Wed, 14 Sep 2011 14:31:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: kaber@trash.net, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Check net->nfnl for NULL in ctnetlink_conntrack_event
 to, avoid Oops on container destroy
Message-ID: <20110914123138.GA19715@1984>
References: <4E6E4961.9070802@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6E4961.9070802@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 12:03:13PM -0600, Tim Gardner wrote:
> Patrick,
> 
> I received this patch from a developer that uses lxc and network
> name spaces. I don't know the locking semantics well enough for CT
> to judge whether this fix is sufficient. Bug info can be found at
> http://bugs.launchpad.net/bugs/843892 . See comment #7 for his
> analysis.

We're still discussing a better solution for it.

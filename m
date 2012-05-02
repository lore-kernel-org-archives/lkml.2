Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2EBA4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:56:10 -0400
Received: from mail.us.es ([193.147.175.20]:43175 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2EBA4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:56:07 -0400
Date: Wed, 2 May 2012 02:56:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: xt_recent: Add optional mask option for
 xt_recent
Message-ID: <20120502005605.GA15074@1984>
References: <1331033084-23803-1-git-send-email-denys@visp.net.lb>
 <20120411231421.GA7038@1984>
 <d8de90a8f08a092730109e72827264fe@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8de90a8f08a092730109e72827264fe@visp.net.lb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:00:03PM +0300, Denys Fedoryshchenko wrote:
[...]
> For me personally it is useful, because i have around 140 NAS
> servers, and i give each of them /24 "gray" subnets, and in some
> cases i need to handle bad users, that are changing dynamic ip and
> attacking from new ip each time. I just block non-critical service
> for whole subnet then, till technician on duty will solve issue
> completely. And sure if attack are stopped, subnet will be unblocked
> "automagically".

OK, if you need this, I'm fine with it.

> Sure this feature not critical, or "a must", and if code are not
> good, it is up to you, if it should be added or not.

I didn't say anything about the code yet. E-mail reviewing this will
follow.

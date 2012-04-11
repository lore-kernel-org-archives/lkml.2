Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab2DKXOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:14:37 -0400
Received: from mail.us.es ([193.147.175.20]:45771 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab2DKXOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:14:34 -0400
Date: Thu, 12 Apr 2012 01:14:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: xt_recent: Add optional mask option for
 xt_recent
Message-ID: <20120411231421.GA7038@1984>
References: <1331033084-23803-1-git-send-email-denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331033084-23803-1-git-send-email-denys@visp.net.lb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

On Tue, Mar 06, 2012 at 01:24:44PM +0200, Denys Fedoryshchenko wrote:
> Use case for this feature:
> 1)In some occasions if you need to allow,block,match specific subnet.
> 2)I can use recent as a trigger when netfilter rule matches, with mask 0.0.0.0
> 
> Example:
> 
> If you ping 8.8.8.8, after that you can't ping 2.2.2.10

Could you provide an useful example for this new feature?

I also think you can make this with hashlimit, that allows you to
set the network mask.

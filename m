Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1FBM74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:59:56 -0400
Received: from mail.us.es ([193.147.175.20]:55635 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1FBM7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:59:52 -0400
Message-ID: <4DE78935.2030904@netfilter.org>
Date: Thu, 02 Jun 2011 14:59:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Julian Anastasov <ja@ssi.bg>,
        Wensong Zhang <wensong@linux-vs.org>
Subject: Re: [PATCH] netfilter, ipvs: Avoid undefined order of evaluation
 in assignments to struct nf_conn *
References: <alpine.LNX.2.00.1105292011450.4411@swampdragon.chaosbits.net> <20110529232337.GD5856@verge.net.au>
In-Reply-To: <20110529232337.GD5856@verge.net.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/11 01:23, Simon Horman wrote:
> Acked-by: Simon Horman <horms@verge.net.au>

applied, thanks

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1FCJjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:39:24 -0400
Received: from mail.us.es ([193.147.175.20]:49164 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab1FCJjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:39:22 -0400
Message-ID: <4DE8ABC4.5060404@netfilter.org>
Date: Fri, 03 Jun 2011 11:39:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joe@perches.com, kaber@trash.net, andy.grover@oracle.com,
        trivial@kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [TRIVIAL PATCH next 15/15] net: Convert vmalloc/memset to vzalloc
References: <cover.1306603968.git.joe@perches.com>	<045996b9688bfaa2efbd8999405a67e23cd0a075.1306603968.git.joe@perches.com>	<4DE7A311.5000406@netfilter.org> <20110602.143927.1073346459383432955.davem@davemloft.net>
In-Reply-To: <20110602.143927.1073346459383432955.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/11 23:39, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Thu, 02 Jun 2011 16:49:53 +0200
> 
>> Are you going to take this patch? it includes one chunck which is out of
>> netfilter scope.
> 
> I think the trivial folks submit these things via their own tree
> and are only looking for ACKs from us.
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

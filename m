Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab2CAMaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:30:16 -0500
Received: from mail.us.es ([193.147.175.20]:52613 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036Ab2CAMaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:30:12 -0500
Date: Thu, 1 Mar 2012 13:30:04 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: bart.de.schuymer@pandora.be, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] netfilter: potential null derefence.
Message-ID: <20120301123004.GA7250@1984>
References: <1330593434-19275-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330593434-19275-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 02:47:14PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> I am getting following error.
> " net/bridge/netfilter/ebtables.c:269 ebt_do_table()
>   error: potential null derefence 'cs'"
> 
>     i = cs[sp].n;  // If cs == Null then this will cause problem.

Very sorry, I didn't see the out label.

I'll apply this to my nf [1] once David takes my previous request for
pulling.

[1] http://1984.lsi.us.es/git/net

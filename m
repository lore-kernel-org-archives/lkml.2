Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0LAJGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:06:32 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:41554 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab0LAJGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:06:30 -0500
Date: Wed, 1 Dec 2010 17:06:21 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Cong Wang <amwang@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, Neil Horman <nhorman@redhat.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Patch] bonding: clean up netpoll code
Message-ID: <20101201090621.GA11366@gondor.apana.org.au>
References: <20101201075043.5741.29172.sendpatchset@localhost.localdomain> <1291190612.2856.481.camel@edumazet-laptop> <4CF606C7.6020606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF606C7.6020606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 04:26:47PM +0800, Cong Wang wrote:
>
> Is this necessary?
> It is just replacing checking IFF_IN_NETPOLL with netpoll_tx_running(),
> you might need to take a look at the bridge code.

I agree with Eric.  The patch does look pretty scary right now.

Each patch should do one thing and one thing only.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

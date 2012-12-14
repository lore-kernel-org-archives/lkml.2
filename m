Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2LNN66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:58:58 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:63329 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab2LNN65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:58:57 -0500
Subject: Re: [PATCH V2] ndisc: Use more standard logging styles
From: Eric Dumazet <erdnetdev@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Duan Jiong <djduanjiong@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <5f9b97d8b6e1a5e1a4e1d7a3731017bae47fb31d.1355458714.git.joe@perches.com>
References: <1355458079.29363.4.camel@joe-AO722>
	 <5f9b97d8b6e1a5e1a4e1d7a3731017bae47fb31d.1355458714.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Dec 2012 05:58:54 -0800
Message-ID: <1355493534.10504.10.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 20:23 -0800, Joe Perches wrote:
> The logging style in this file is "baroque".
> 
> Convert indirect uses of net_<level>_ratelimited to
> simply use net_<level>_ratelimited.
> 
> Add a nd_dbg macro and #define ND_DEBUG for the other
> generally inactivated logging messages.
> 
> Make those inactivated messages emit only at KERN_DEBUG
> instead of other levels.  Add "%s: " __func__ to all
> these nd_dbg macros and remove the embedded function
> names and prefixes.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

It seems its not a bug fix, so why are you sending this now ?

Is it so hard to understand the merge window rule ?

net-next is currently closed.



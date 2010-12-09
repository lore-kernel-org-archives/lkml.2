Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0LIPXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:23:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0LIPXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:23:40 -0500
Date: Thu, 9 Dec 2010 16:23:34 +0100
From: Holger Eitzenberger <holger@eitzenberger.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: ctnetlink loop
Message-ID: <20101209152334.GA7765@mail.eitzenberger.org>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
References: <20101203133903.GG13225@mail.eitzenberger.org> <4D00B5CD.3050406@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D00B5CD.3050406@netfilter.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V02:K0:2awkK8/hJ77tXjjYUSZg2xJBcUWm2Z6aETt4XB1pQf6
 /m4/mlzcLdF10pki6HdFegFykRZihbUsrcC/2drXkD5pEz9OJ4
 gk/V+S24tEJsy3ZTxR2u1/4F7IcpBlzRjXkKg45ViWRjBXWxZ4
 i7XLzbAjWTYpl6X/00TdtYLpjThKsvVId8HffIfY6xJseuHJCK
 bfr/Z5NyEBqzLu4/4jp04Q+YcFNMmPu3Y1weenzky0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I finally found your email reporting this:
> 
> > nfnetlink: avoid unbound loop on busy Netlink socket

Fair enough, thanks.

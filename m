Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1KIByU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:54:20 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35897 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1KIByS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:54:18 -0500
Date: Wed, 9 Nov 2011 09:54:06 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: danila.st@mail.ru, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        adobriyan@gmail.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: Add IPSec IP Range in Linux kernel
Message-ID: <20111109015406.GA10800@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108.204253.891598837549584662.davem@davemloft.net>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apa
	na.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
> Like I said, if you want address ranges, ask the userland IPSEC daemon
> authors to synthesize it.

Alternatively you can do this with marking and use netfilter
to set the mark.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

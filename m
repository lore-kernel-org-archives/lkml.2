Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2GKDZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:25:54 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:43143 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754478Ab2GKDZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:25:51 -0400
Date: Wed, 11 Jul 2012 11:25:37 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, plagnioj@jcrosoft.com, nicolas@eukrea.com
Subject: Re: [PATCH 0/5] AT91SAM9G46/M11: add crypto drivers
Message-ID: <20120711032537.GF5263@gondor.apana.org.au>
References: <1341163187-14946-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1341163187-14946-1-git-send-email-eric@eukrea.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 07:19:42PM +0200, Eric Bénard wrote:
> This patch serie adds the support for the crypto engine available in
> the Atmel SAM9G46 http://www.atmel.com/devices/SAM9G46.aspx and SAM9M11
> http://www.atmel.com/devices/SAM9M11.aspx
> 
> For each driver the choice between PDC/DMA or PIO was optimized to
> maximize the performances (benchmarks will soon be available on
> the linux4sam wiki http://www.at91.com/).
> 
> These drivers were tested on both devices : the last patch adds a few
> missing tests to tcrypt.
> 
> This work was sponsored by Atmel.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

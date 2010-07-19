Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0GSGGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 02:06:21 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:55177 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab0GSGGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 02:06:19 -0400
Date: Mon, 19 Jul 2010 14:05:59 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roel Kluin <roel.kluin@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Chihau Chau <chihau@gmail.com>, linux-geode@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/25] crypto: Convert pci_table entries to PCI_VDEVICE
	(if PCI_ANY_ID is used)
Message-ID: <20100719060559.GA19793@gondor.apana.org.au>
References: <201007152100.42276.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007152100.42276.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 09:00:41PM +0200, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
> PCI_VDEVICE macro, and thus improves readability.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

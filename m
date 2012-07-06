Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2GFN00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:26:26 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:53720 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2GFN0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:26:24 -0400
Date: Fri, 6 Jul 2012 15:25:21 +0200
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net, nicolas@eukrea.com
Subject: Re: [PATCH 2/5] crypto: add Atmel AES driver
Message-ID: <20120706152521.5145f1aa@eb-e6520>
In-Reply-To: <20120706121719.GD4450@game.jcrosoft.org>
References: <1341163187-14946-1-git-send-email-eric@eukrea.com>
	<1341163187-14946-3-git-send-email-eric@eukrea.com>
	<20120706121719.GD4450@game.jcrosoft.org>
Organization: =?ISO-8859-1?B?RXVrculh?= Electromatique
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Christophe,

Le Fri, 6 Jul 2012 14:17:19 +0200,
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> a écrit :
> > +	u8	buf_in[ATMEL_AES_DMA_THRESHOLD] __aligned(sizeof(u32));
> can you allocate it
> > +	int	dma_in;
> > +	struct atmel_aes_dma	dma_lch_in;
> > +
> > +	u8	buf_out[ATMEL_AES_DMA_THRESHOLD] __aligned(sizeof(u32));
> ditto
> 
Why is that preferred to allocate dynamicaly these buffers (we are
talking of 2 x 16 bytes buffers) ?

> otherwise looks good
> 
thanks

Eric

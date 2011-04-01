Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab1DATnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:43:20 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:23875
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab1DATnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:43:18 -0400
X-SpamScore: -11
X-BigFish: VS-11(zz1432N9370J98dKzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 1 Apr 2011 14:42:05 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Julia Lawall <julia@diku.dk>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steve Cornelius <sec@pobox.com>, Dan Carpenter <error27@gmail.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] drivers/crypto/caam/caamalg.c: introduce missing
 kfree
Message-ID: <20110401144205.b050c598.kim.phillips@freescale.com>
In-Reply-To: <1301667827-20056-2-git-send-email-julia@diku.dk>
References: <1301667827-20056-2-git-send-email-julia@diku.dk>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011 16:23:43 +0200
Julia Lawall <julia@diku.dk> wrote:

> Error handling code following a kmalloc should free the allocated data.

> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Kim


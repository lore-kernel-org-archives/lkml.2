Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2KWQEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:04:46 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56343 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2KWQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 11:04:44 -0500
MIME-Version: 1.0
In-Reply-To: <1353678541-26839-1-git-send-email-nicolas.ferre@atmel.com>
References: <1353678541-26839-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 23 Nov 2012 17:04:42 +0100
Message-ID: <CAGhQ9Vw=Yk7RAMVsBM71QWNjsD99PnrTgRs5+pK8V2e=HirQqg@mail.gmail.com>
Subject: Re: [PATCH] net/macb: GEM DMA configuration register update
From: Joachim Eastwood <manabian@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 14:49, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Add information to the DMA Configuration Register to
> maximize system performance:
> - rx/tx packet buffer full memory size
> - allow possibility to use INCR16 if supported
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Joachim Eastwood <manabian@gmail.com

regards
Joachim Eastwood

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498Ab0KQUkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:40:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54298
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932364Ab0KQUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:40:18 -0500
Date: Wed, 17 Nov 2010 12:40:43 -0800 (PST)
Message-Id: <20101117.124043.52191671.davem@davemloft.net>
To: nikai@nikai.net
Cc: galak@kernel.crashing.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gianfar: fix signedness issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101115215942.354b0394@absol.kitzblitz>
References: <20101115215942.354b0394@absol.kitzblitz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Kaiser <nikai@nikai.net>
Date: Mon, 15 Nov 2010 21:59:42 +0100

> irq_of_parse_and_map() has an unsigned return type.
> Testing for a negative error value doesn't work here.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> I see that in numerous places the return value is tested
> for NO_IRQ. I hope it's the right thing to do here as well?

I think it is, applied, thank you.

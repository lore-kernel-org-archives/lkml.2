Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0HQD4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 23:56:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33473
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731Ab0HQD4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 23:56:51 -0400
Date: Mon, 16 Aug 2010 20:57:09 -0700 (PDT)
Message-Id: <20100816.205709.71100683.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: julia@diku.dk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/42] drivers/net/wan: Adjust confusing if indentation
From: David Miller <davem@davemloft.net>
In-Reply-To: <m37hk21tv2.fsf@intrepid.localdomain>
References: <Pine.LNX.4.64.1008052216400.31692@ask.diku.dk>
	<m37hk21tv2.fsf@intrepid.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 07 Aug 2010 14:37:37 +0200

> Julia Lawall <julia@diku.dk> writes:
> 
>>  drivers/net/wan/c101.c      |    2 +-
>>  drivers/net/wan/n2.c        |    2 +-
>>  drivers/net/wan/pci200syn.c |    2 +-
> 
> Fully Acked-by: Krzysztof Ha©©asa <khc@pm.waw.pl>

Please don't use non-standard commit tags like this "Fully Acked-by:"
thing, otherwise automated tools won't notice and pick them up
properly.

Thanks.

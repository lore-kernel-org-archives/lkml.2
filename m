Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab0KRSfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:35:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32808
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932821Ab0KRSfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:35:54 -0500
Date: Thu, 18 Nov 2010 10:36:18 -0800 (PST)
Message-Id: <20101118.103618.102550300.davem@davemloft.net>
To: segoon@openwall.com
Cc: kernel-janitors@vger.kernel.org, sjur.brandeland@stericsson.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] net: caif: spi: fix potential NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290104226-31428-1-git-send-email-segoon@openwall.com>
References: <1290104226-31428-1-git-send-email-segoon@openwall.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Thu, 18 Nov 2010 21:17:05 +0300

> alloc_netdev() is not checked here for NULL return value.  dev is
> check instead.  It might lead to NULL dereference of ndev.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested.
>  Maybe dev is also must be checked here, but it looks like a trivial typo.

Definitely looks correct to me, applied, thanks!

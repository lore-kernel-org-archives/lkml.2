Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab2KDRlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:41:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39314 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2KDRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:41:07 -0500
Date: Sun, 04 Nov 2012 12:41:05 -0500 (EST)
Message-Id: <20121104.124105.1180255461095055631.davem@davemloft.net>
To: axel.lin@ingics.com
Cc: herbert@gondor.hengli.com.au, jamie@jamieiles.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: picoxcell: Add terminating entry for
 platform_device_id table
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352043385.11324.4.camel@phoenix>
References: <1352043385.11324.4.camel@phoenix>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>
Date: Sun, 04 Nov 2012 23:36:25 +0800

> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: David S. Miller <davem@davemloft.net>

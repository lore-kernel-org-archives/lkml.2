Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0EXGLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:11:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51793
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430Ab0EXGLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:11:15 -0400
Date: Sun, 23 May 2010 23:11:24 -0700 (PDT)
Message-Id: <20100523.231124.236272338.davem@davemloft.net>
To: thomas@wytron.com.tw
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       thierry.reding@avionic-design.de, nios2-dev@sopc.et.ntust.edu.tw,
       error27@gmail.com
Subject: Re: [PATCH] ethoc: fix null dereference in ethoc_probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274669042-1901-1-git-send-email-thomas@wytron.com.tw>
References: <20100522155455.GE22515@bicker>
	<1274669042-1901-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Chou <thomas@wytron.com.tw>
Date: Mon, 24 May 2010 10:44:02 +0800

> Dan reported the patch 0baa080c75c: "ethoc: use system memory
> as buffer" introduced a potential null dereference.
> 
>   1060  free:
>   1061          if (priv->dma_alloc)
>                     ^^^^^^^^^^^^^^^
> 	priv can be null here.
> 
> He also suggested that the error handling is not complete.
> 
> This patch fixes the null priv issue and improves resources
> releasing in ethoc_probe() and ethoc_remove().
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

Applied.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265Ab0IIWCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:02:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34395
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638Ab0IIWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:02:46 -0400
Date: Thu, 09 Sep 2010 15:03:04 -0700 (PDT)
Message-Id: <20100909.150304.246518344.davem@davemloft.net>
To: namhyung@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net/core: add lock context change annotations in
 net/core/sock.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283953728-15302-2-git-send-email-namhyung@gmail.com>
References: <1283953728-15302-1-git-send-email-namhyung@gmail.com>
	<1283953728-15302-2-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Wed,  8 Sep 2010 22:48:48 +0900

> __lock_sock() and __release_sock() releases and regrabs lock but
> were missing proper annotations. Add it. This removes following
> warning from sparse. (Currently __lock_sock() does not emit any
> warning about it but I think it is better to add also.)
> 
>  net/core/sock.c:1580:17: warning: context imbalance in '__release_sock' - unexpected unlock
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Applied.

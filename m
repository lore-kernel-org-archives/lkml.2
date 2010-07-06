Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab0GFDIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 23:08:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37160
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab0GFDIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 23:08:02 -0400
Date: Mon, 05 Jul 2010 20:08:16 -0700 (PDT)
Message-Id: <20100705.200816.57450933.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, joe@perches.com, anemo@mba.ocn.ne.jp,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ne: fix memory leak in ne_drv_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278170444-8170-1-git-send-email-segooon@gmail.com>
References: <1278170444-8170-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>
Date: Sat,  3 Jul 2010 19:20:42 +0400

> net_device allocated with alloc_eip_netdev() must be freed.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Applied, thanks.

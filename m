Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0IGB3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:29:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50276
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab0IGB3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:29:18 -0400
Date: Mon, 06 Sep 2010 18:29:35 -0700 (PDT)
Message-Id: <20100906.182935.212701145.davem@davemloft.net>
To: julia@diku.dk
Cc: pantelis.antoniou@gmail.com, kernel-janitors@vger.kernel.org,
        vbordug@ru.mvista.com, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] drivers/net/fs_enet/fs_enet-main.c: Add
 of_node_put to avoid memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283595164-29146-1-git-send-email-julia@diku.dk>
References: <1283595164-29146-1-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat,  4 Sep 2010 12:12:43 +0200

> In this case, a device_node structure is stored in another structure that
> is then freed without first decrementing the reference count of the
> device_node structure.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.

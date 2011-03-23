Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab1CWVKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:10:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42585
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756202Ab1CWVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:10:20 -0400
Date: Wed, 23 Mar 2011 14:10:59 -0700 (PDT)
Message-Id: <20110323.141059.27811716.davem@davemloft.net>
To: julia@diku.dk
Cc: kernel-janitors@vger.kernel.org, eric.dumazet@gmail.com, tj@kernel.org,
        jpirko@redhat.com, geert@linux-m68k.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/net/a2065.c: Convert release_resource to
 release_region/release_mem_region
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300814123-25314-3-git-send-email-julia@diku.dk>
References: <1300814123-25314-3-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 22 Mar 2011 18:15:23 +0100

> Request_mem_region should be used with release_mem_region, not
> release_resource.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.

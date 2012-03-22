Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030513Ab2CVCRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:17:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48764 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2CVCRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:17:18 -0400
Date: Wed, 21 Mar 2012 22:16:10 -0400 (EDT)
Message-Id: <20120321.221610.1111479562922750614.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 09/11] net/ariadne: Improve debug prints
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332323515-7314-9-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
	<1332323515-7314-9-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Mar 2012 19:16:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 21 Mar 2012 10:51:53 +0100

> Remove casts and use proper printf()-style format specifiers instead.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

You can merge these in via the m68k tree if you want.

Acked-by: David S. Miller <davem@davemloft.net>

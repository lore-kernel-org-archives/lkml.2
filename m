Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab0CVETM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:19:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59782
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850Ab0CVETK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:19:10 -0400
Date: Sun, 21 Mar 2010 21:19:33 -0700 (PDT)
Message-Id: <20100321.211933.35812457.davem@davemloft.net>
To: paulius.zaleckas@gmail.com
Cc: contact@saschahlusiak.de, eric.dumazet@gmail.com,
       Fred.L.Templin@boeing.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] if_tunnel.h: add missing ams/byteorder.h include
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100319150926.11037.39136.stgit@pauliusz>
References: <20100319150926.11037.39136.stgit@pauliusz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Date: Fri, 19 Mar 2010 17:09:26 +0200

> When compiling userspace application which includes
> if_tunnel.h and uses GRE_* defines you will get undefined
> reference to __cpu_to_be16.
> 
> Fix this by adding missing #include <asm/byteorder.h>
> 
> Cc: stable@kernel.org
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>

This slipped through the cracks, someone else submitted something
similar back in August 2009 it seems.

Thanks for sending this, applied.

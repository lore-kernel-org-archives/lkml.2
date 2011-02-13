Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1BMTVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 14:21:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59183
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606Ab1BMTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 14:21:03 -0500
Date: Sun, 13 Feb 2011 11:21:39 -0800 (PST)
Message-Id: <20110213.112139.91321217.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, adobriyan@gmail.com,
        error27@gmail.com, shmulikr@broadcom.com, john.r.fastabend@intel.com,
        lucy.liu@intel.com
Subject: Re: [PATCH] Don't potentially dereference NULL in
 net/dcb/dcbnl.c:dcbnl_getapp()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1102102253230.8012@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102102253230.8012@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 10 Feb 2011 22:57:16 +0100 (CET)

> nla_nest_start() may return NULL. If it does then we'll blow up in 
> nla_nest_end() when we dereference the pointer.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.

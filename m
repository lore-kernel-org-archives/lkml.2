Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1CPSOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:14:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58040
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218Ab1CPSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:14:31 -0400
Date: Wed, 16 Mar 2011 11:15:08 -0700 (PDT)
Message-Id: <20110316.111508.59677457.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: frank.peters@comcast.net, linux-kernel@vger.kernel.org,
        bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org
Subject: Re: 2.6.38 Compile Failure e1000e Module
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300288617.3202.10.camel@edumazet-laptop>
References: <20110316103318.19bd03e4.frank.peters@comcast.net>
	<1300288617.3202.10.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 16 Mar 2011 16:16:57 +0100

> [PATCH] e1000e: fix kconfig for crc32 dependency
> 
> ERROR: "crc32_le" [drivers/net/e1000e/e1000e.ko] undefined!
> 
> Reported-by: Frank Peters <frank.peters@comcast.net>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied, thanks Eric.

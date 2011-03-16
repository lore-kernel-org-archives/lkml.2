Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1CPSPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:15:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58046
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218Ab1CPSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:15:06 -0400
Date: Wed, 16 Mar 2011 11:15:44 -0700 (PDT)
Message-Id: <20110316.111544.115931576.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: frank.peters@comcast.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: 2.6.38 Compile Failure e1000e Module
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110316082105.c911bb1c.randy.dunlap@oracle.com>
References: <20110316103318.19bd03e4.frank.peters@comcast.net>
	<20110316082105.c911bb1c.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 16 Mar 2011 08:21:05 -0700

> Hi,
> Please test this patch:
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> e1000e needs to select CRC32 for CRC support.
> This patch fixes the build error:
> ERROR: "crc32_le" [drivers/net/e1000e/e1000e.ko] undefined!
> 
> Reported-by: Frank Peters <frank.peters@comcast.net>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Randy, I applied Eric Dumazet's copy of this fix only because
his submission preceded your's in terms of time of submission :-)

Thanks!

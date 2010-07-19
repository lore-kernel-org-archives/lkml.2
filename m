Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966696Ab0GSUQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:16:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39923
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966682Ab0GSUQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:16:05 -0400
Date: Mon, 19 Jul 2010 13:16:21 -0700 (PDT)
Message-Id: <20100719.131621.172566230.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [5/5] Respect the
 interrupt type in VM configuration
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007151458580.10176@localhost.localdomain>
References: <alpine.LRH.2.00.1007131750060.32055@localhost.localdomain>
	<20100714.141118.260092331.davem@davemloft.net>
	<alpine.LRH.2.00.1007151458580.10176@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Thu, 15 Jul 2010 18:21:27 -0700 (PDT)

> Respect the interrupt type set in VM configuration.
> 
> When interrupt type is not auto, do not ignore the interrupt type set from
> VM configuration.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

Applied.

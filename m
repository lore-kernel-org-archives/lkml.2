Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935409Ab0GPCHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:07:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38788
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935356Ab0GPCHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:07:42 -0400
Date: Thu, 15 Jul 2010 19:07:57 -0700 (PDT)
Message-Id: <20100715.190757.70186039.davem@davemloft.net>
To: mcuos.com@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/nuc900: enable Mac driver clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C3D87FD.6030101@gmail.com>
References: <4C3D87FD.6030101@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wan ZongShun <mcuos.com@gmail.com>
Date: Wed, 14 Jul 2010 17:48:45 +0800

> This patch fixed a bug that Mac driver does not work,because I missed the clk enable.
> 
> I have ever tested the driver when I submitted previous Mac driver patch,
> and it worked good, since my bootloader has enabled the clock in advance.
> 
> But when I try to use other bootloader where clock engine was disabled,the
> Mac driver does not work, so I send this patch to fix this issue.
> 
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

Applied, thank you.

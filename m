Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2DAULa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:11:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44334 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2DAULP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:11:15 -0400
Date: Sun, 01 Apr 2012 16:11:11 -0400 (EDT)
Message-Id: <20120401.161111.373860957994363057.davem@davemloft.net>
To: LinoSanfilippo@gmx.de
Cc: shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: fix missing register reset on error path in
 sky2_test_msi()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120330173616.GC2703@Neptun>
References: <20120330173616.GC2703@Neptun>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 13:11:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Date: Fri, 30 Mar 2012 19:36:16 +0200

> In sky2_test_msi() the temporarily set SW IRQ in B0 register is not reset in case
> that request_irq() fails.
> With this patch we only set the interrupt mask if request_irq() was successful.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Stephen, ping?

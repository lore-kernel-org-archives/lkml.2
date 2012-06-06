Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab2FFRho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:37:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37661 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2FFRhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:37:42 -0400
Date: Wed, 06 Jun 2012 10:37:41 -0700 (PDT)
Message-Id: <20120606.103741.1134656571479190113.davem@davemloft.net>
To: christian.dietrich@informatik.uni-erlangen.de
Cc: sshtylyov@mvista.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de
Subject: Re: [PATCH] ide: icside.c: Fix compile with
 CONFIG_BLK_DEV_IDEDMA_ICS=n
From: David Miller <davem@davemloft.net>
In-Reply-To: <864nqq3q2v.fsf@gandalf.zerties.org>
References: <86lik87jgw.fsf@gandalf.zerties.org>
	<20120602.171210.1245211360510437081.davem@davemloft.net>
	<864nqq3q2v.fsf@gandalf.zerties.org>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Date: Tue, 05 Jun 2012 14:23:20 +0200

> The icside driver can be configured without DMA support, but it
> doesn't compile then, because DMA operations are referenced.
> 
> drivers/ide/icside.c:523: error: 'icside_v6_port_ops' undeclared
> drivers/ide/icside.c:522: error: 'icside_dma_init' undeclared
> 
> Signed-off-by: Christian Dietrich<christian.dietrich@informatik.uni-erlangen.de>

Applied.

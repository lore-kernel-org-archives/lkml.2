Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0F2DLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:11:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46817
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab0F2DLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:11:16 -0400
Date: Mon, 28 Jun 2010 20:11:28 -0700 (PDT)
Message-Id: <20100628.201128.246530984.davem@davemloft.net>
To: dilinger@queued.net
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, wmb@laptop.org, pgf@laptop.org,
       linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code out into drivers/of
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100628220037.5744c207@debian>
References: <20100628215407.2017bf2f@debian>
	<20100628220037.5744c207@debian>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>
Date: Mon, 28 Jun 2010 22:00:37 -0400

> 
> Stick code into drivers/of/pdt.c (Prom Device Tree) that other
> architectures with OpenFirmware resident in memory can make use of.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: David S. Miller <davem@davemloft.net>

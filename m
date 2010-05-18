Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab0ERGMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:12:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58819
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787Ab0ERGMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:12:47 -0400
Date: Mon, 17 May 2010 23:12:56 -0700 (PDT)
Message-Id: <20100517.231256.146340344.davem@davemloft.net>
To: aeb@debian.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ARCNET: Limit com20020 PCI ID matches for SOHARD cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100512004852.GA25845@amos.infernal>
References: <20100512004852.GA25845@amos.infernal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Bombe <aeb@debian.org>
Date: Wed, 12 May 2010 02:49:06 +0200

> The SH SOHARD ARCNET cards are implemented using generic PLX Technology
> PCI<->IOBus bridges. Subvendor and subdevice IDs were not specified,
> causing the driver to attach to any such bridge and likely crash the
> system by attempting to initialize an unrelated device.
> 
> Fix by specifying subvendor and subdevice according to the values found
> in the PCI-ID Repository at http://pci-ids.ucw.cz/ .
> 
> Cc: stable@kernel.org
> Signed-off-by: Andreas Bombe <aeb@debian.org>

Applied, thank you.

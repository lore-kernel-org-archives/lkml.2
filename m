Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348Ab0GPCGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:06:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49844
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935335Ab0GPCGt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:06:49 -0400
Date: Thu, 15 Jul 2010 19:07:04 -0700 (PDT)
Message-Id: <20100715.190704.246538713.davem@davemloft.net>
To: PeterHuewe@gmx.de
Cc: kernel-janitors@vger.kernel.org, isdn@linux-pingi.de,
        akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de,
        tj@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/25] mISDN: Convert pci_table entries to PCI_VDEVICE
 (if PCI_ANY_ID is used)
From: David Miller <davem@davemloft.net>
In-Reply-To: <201007152104.08458.PeterHuewe@gmx.de>
References: <201007152104.08458.PeterHuewe@gmx.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hüwe <PeterHuewe@gmx.de>
Date: Thu, 15 Jul 2010 21:04:07 +0200

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
> PCI_VDEVICE macro, and thus improves readability.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437Ab0GPCJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:09:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49811
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935291Ab0GPCGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:06:17 -0400
Date: Thu, 15 Jul 2010 19:06:32 -0700 (PDT)
Message-Id: <20100715.190632.59688957.davem@davemloft.net>
To: PeterHuewe@gmx.de
Cc: kernel-janitors@vger.kernel.org, chas@cmf.nrl.navy.mil,
        hsweeten@visionengravers.com, tj@kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/25] atm: Convert pci_table entries to PCI_VDEVICE
 (if PCI_ANY_ID is used)
From: David Miller <davem@davemloft.net>
In-Reply-To: <201007152045.33543.PeterHuewe@gmx.de>
References: <201007152045.33543.PeterHuewe@gmx.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>
Date: Thu, 15 Jul 2010 20:45:32 +0200

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
> PCI_VDEVICE macro, and thus improves readability.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0CQE2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:28:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36018
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab0CQE2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:28:18 -0400
Date: Tue, 16 Mar 2010 21:28:40 -0700 (PDT)
Message-Id: <20100316.212840.211879050.davem@davemloft.net>
To: jgunthorpe@obsidianresearch.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: Support clause 45 MDIO commands at the MDIO bus
 level
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100309191742.GB30462@obsidianresearch.com>
References: <20100309191742.GB30462@obsidianresearch.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Tue, 9 Mar 2010 12:17:42 -0700

> IEEE 802.3ae clause 45 specifies a somewhat modified MDIO protocol
> for use by 10GIGE phys. The main change is a 21 bit address split into
> a 5 bit device ID and a 16 bit register offset. The definition is designed
> so that normal and extended devices can run on the same MDIO bus.
> 
> Extend mdio-bitbang to do the new protocol. At the MDIO bus level the
> protocol is requested by or'ing MII_ADDR_C45 into the register offset.
> 
> Make phy_read/phy_write/etc pass a full 32 bit register offset.
> 
> This does not attempt to make the phy layer support C45 style PHYs, just
> to provide the MDIO bus support.
> 
> Tested against a Broadcom 10GE phy with ID 0x206034, and several
> Broadcom 10/100/1000 Phys in normal mode.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Applied.

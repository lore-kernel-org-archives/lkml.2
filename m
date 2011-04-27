Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab1D0UxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:53:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50699
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756589Ab1D0UxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:53:13 -0400
Date: Wed, 27 Apr 2011 13:52:40 -0700 (PDT)
Message-Id: <20110427.135240.112610984.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH net-next] r8169: fix merge conflict fix.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110427203640.GC19708@electric-eye.fr.zoreil.com>
References: <20110427203640.GC19708@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 27 Apr 2011 22:36:40 +0200

> - use adequate MAC_VER id
>   (see 01dc7fec4025f6bb72b6b98ec88b375346b6dbbb)
> - remove duplicate rtl_firmware_info record
> - remove duplicate functions
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>

Applied, thanks.

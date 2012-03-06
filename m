Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031158Ab2CFWMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:12:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab2CFWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:12:45 -0500
Date: Tue, 06 Mar 2012 17:08:28 -0500 (EST)
Message-Id: <20120306.170828.2286313308907964046.davem@davemloft.net>
To: dhdang@apm.com
Cc: benh@kernel.crashing.org, paulus@samba.org, jwboyer@gmail.com, sr@denx.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] powerpc/44x: Add more changes for APM821XX EMAC
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330945102-15802-1-git-send-email-dhdang@apm.com>
References: <1330920224-3006-1-git-send-email-dhdang@apm.com>
	<1330945102-15802-1-git-send-email-dhdang@apm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Mar 2012 14:08:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duc Dang <dhdang@apm.com>
Date: Mon,  5 Mar 2012 17:58:22 +0700

>  This patch includes:
> 
>   Configure EMAC PHY clock source (clock from PHY or internal clock).
> 
>   Do not advertise PHY half duplex capability as APM821XX EMAC does not support half duplex mode.
> 
>   Add changes to support configuring jumbo frame for APM821XX EMAC.
> 
> Signed-off-by: Duc Dang <dhdang@apm.com>

Applied with coding style fixes.

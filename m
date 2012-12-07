Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423561Ab2LGRsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:48:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56909 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423478Ab2LGRsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:48:37 -0500
Date: Fri, 07 Dec 2012 12:48:35 -0500 (EST)
Message-Id: <20121207.124835.728462205614919465.davem@davemloft.net>
To: tremyfr@yahoo.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        otavio@ossystems.com.br, javier@dowhile0.org, jkosina@suse.cz,
        eric.jarrige@armadeus.org, julien.boibessot@armadeus.com,
        thomas.petazzoni@free-electrons.com
Subject: Re: [PATCH v2] net: phy: smsc: force all capable mode if the phy
 is started in powerdown mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354647130-1854-1-git-send-email-tremyfr@yahoo.fr>
References: <1354647130-1854-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Reynes <tremyfr@yahoo.fr>
Date: Tue,  4 Dec 2012 19:52:10 +0100

> A SMSC PHY in power down mode can't be used.
> If a SMSC PHY is in this mode in the config_init
> stage, the mode "all capable" is set. So the PHY
> could then be used.
> 
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>

Applied, thanks.

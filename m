Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2DBTil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:38:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2DBTij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:38:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 3/8] net: Add device tree support to LPC32xx
Date: Mon, 2 Apr 2012 19:37:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be, jonsmirl@gmail.com
References: <1333391587-26290-1-git-send-email-stigge@antcom.de> <1333391587-26290-4-git-send-email-stigge@antcom.de>
In-Reply-To: <1333391587-26290-4-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204021937.54567.arnd@arndb.de>
X-Provags-ID: V02:K0:OvmWhb3D814YjeviouciQnKEOyhhs0BuncRzRsPYB1v
 TcHxM7zKsk7tMq4sEKk/bQOPsAlXqZFhogZA6grdX8EJSyOJha
 lQQ/zCkeLqmlljimfznnZ9Wm+goH9euyFSSZOsJRg/I9Hg9p85
 TVpJbyHTDlngJ8RPCbzbDE5eKkYTr3ACynxuyd5gOpwmjOSoRo
 +KfMCs7i10t1FlaLTkGoiZRg5rCpSzj964sldE8RmIMXHc9AZ3
 HCIpTBU9XyfLPG33JxlkMkn3OGRNNUJlKaSFlwd0zWw2glF64e
 yxHd2pqhvidsWXNgxxN4pGAre6ibtIYhSoJeqlOTX5FXVZVas2
 ShAMZ+dt3/rzB2QYmK7w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2012, Roland Stigge wrote:
> 
> +       if (pdev->dev.of_node && of_get_property(pdev->dev.of_node,
> +                                                "use-iram", NULL))
> +               pldat->use_iram = true;
> +       else
> +               pldat->use_iram = false;
> +

One more thing I just noticed:

this is equivalent to the much shorter 

	pldat->use_iram = of_property_read_bool(pdev->dev.of_node, "use-iram");

Everything else looks good here.

	Arnd

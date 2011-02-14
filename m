Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1BNVhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 16:37:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab1BNVhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 16:37:17 -0500
Date: Mon, 14 Feb 2011 13:37:53 -0800 (PST)
Message-Id: <20110214.133753.102561672.davem@davemloft.net>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, tomoya-linux@dsn.okisemi.com,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_gbe: Fix the MAC Address load issue.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D58ED2A.9050706@dsn.okisemi.com>
References: <4D58ED2A.9050706@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Mon, 14 Feb 2011 17:51:54 +0900

> With the specification of hardware,
> the processing at the time of driver starting was modified.
> 
> This device write automatically the MAC address read from serial ROM
> into a MAC Adress1A/1B register at the time of power on reset.
> However, when stable clock is not supplied,
> the writing of MAC Adress1A/1B register may not be completed.
> In this case, it is necessary to load MAC address to MAC Address1A/1B register
> by the MAC Address1 load register.
> 
> This patch always does the above processing,
> in order not to be dependent on system environment.
> 
> Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

Applied.

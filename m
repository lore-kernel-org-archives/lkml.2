Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2CSVah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:30:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2CSVaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:30:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] USB: gadget driver for LPC32xx
Date: Mon, 19 Mar 2012 21:30:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        srinivas.bakki@nxp.com
References: <1332191930-2433-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1332191930-2433-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201203192130.13583.arnd@arndb.de>
X-Provags-ID: V02:K0:UNH4ssjvd8B5d29N2ifamB2ckGx7fEbDEVpq7exnh3K
 t8GHmMF+Nq+0SdnxNk2NrLtUzHXomX1thcrHeC6ec8fGDBiorO
 xXgQeE9SWYuQOG0Qg5MtALzkF8JuO0NmGvYHJKVLNMJjvPgjAT
 p1bLk3c8m694odaoSdqbaYwlDoiIn2HCQ0XdWjNFqJzMaY/d9C
 7SyVM7oraJTuVSE3YWPMVPHXyrU5AiJfDlN0BWq8T6bNxoSsBz
 JJ6i1lyDKbKpyn1oE9xrhLYVq9IwTaiNFwCWXn0PwyGZabZCpu
 N8tkwnduBjkBkPvjceG/CxmXBESZVqf5I4O3jVWmPKcbk3xT91
 WbBzr5GWKl9DgJKbmmw0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2012, Roland Stigge wrote:
> This patch adds a USB gadget driver.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
> 
> Applies to v3.3
> 
> 
>  drivers/usb/gadget/Kconfig        |   10 
>  drivers/usb/gadget/Makefile       |    1 
>  drivers/usb/gadget/gadget_chips.h |    3 
>  drivers/usb/gadget/lpc32xx_udc.c  | 3598 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 3612 insertions(+)

Hi Roland,

There is already a driver for the isp1301 otg part in the kernel, I don't
think we want to add another one.

>From what I can tell, this shares a common ancestry with the omap version
but has diverged quite a bit. The best solution would really be to
bring the two back together and let them share a common base driver,
with the lpc32xx and omap specific bits in another file.

	Arnd

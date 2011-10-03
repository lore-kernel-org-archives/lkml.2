Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1JCJkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:40:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56196 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1JCJkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:40:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 15/30] usb/musb: use a Kconfig choice to pick the right DMA method
Date: Mon, 03 Oct 2011 11:40:26 +0200
Message-ID: <3529819.LQllWhb43D@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002221050.GA25790@legolas.emea.dhcp.ti.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1546914.88vcgxkfJf@wuerfel> <20111002221050.GA25790@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1gghC9PkUKXm+JtZWOQB70+2uMQxaxhOINJj0wE3sev
 PQXjtLDtRCSMXt0k3mhhNehjgMGzMSPenbk62VRW3HDQp0uctm
 ub5sKEwme0p8oPlhjMU86q0jmylw9Q5eXXg50hppWZ+3ww6NIi
 sKu+17zchAO7+xdORWQPBcZgdpMAM3jaxsXwtRtU8ryudomm26
 VECdgWhGyhqopZu6nLIivsEbNBTTf9Tc3Y66N0N1p7CkCU3RgP
 HdRA1QjiASnx8r5SOhItdUgflb7/tnnpsgMDpv/THBnvcqM5ln
 nu3T3gqT1yr/zvlEz9b/wJRUzQL5zR+KFqkRwpS0afIUxRxw+5
 TiJSiQ5djr5JY04UY3JU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 01:10:51 Felipe Balbi wrote:
> Anyway, I'll take your patches in, but their too late for this merge
> window  I already sent my last pull to Greg.

No problem. I need the full set of arm-randconfig patches upstream in order
to make randconfig work in general, and that's not happening for 3.2
anyway. Right now, I'm just trying to as many patches as possible into
maintainer trees.

Is your tree part of linux-next, or will it only show up after the merge
window once Greg has pulled your first set for 3.3?

	Arnd

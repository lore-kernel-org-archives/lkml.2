Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab1JCG7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 02:59:50 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60992 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab1JCG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 02:59:42 -0400
Subject: Re: [PATCH 03/30] video/omap: fix build dependencies
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1317566760-25681-4-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
	 <1317566760-25681-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 09:59:35 +0300
Message-ID: <1317625175.2026.8.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, 2011-10-02 at 16:45 +0200, Arnd Bergmann wrote:
> Four of the LCD panel drivers depend on the backlight class,
> so add the dependency in Kconfig.
> Selecting the BACKLIGHT_CLASS_DEVICE symbol does not generally
> work since it has other dependencies.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>

This looks ok to me. If it's fine to you, I'll queue this patch in my
DSS tree to prevent possible conflicts.

 Tomi



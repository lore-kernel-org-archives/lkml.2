Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2JOQHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:07:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59573 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2JOQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:07:46 -0400
Date: Mon, 15 Oct 2012 17:07:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Chris Ball <cjb@laptop.org>,
        Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: core: Support all MMC capabilities when booting
 from Device Tree
Message-ID: <20121015160740.GC7662@gmail.com>
References: <1350306959-5843-1-git-send-email-lee.jones@linaro.org>
 <201210151420.29930.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201210151420.29930.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 15 October 2012, Lee Jones wrote:
> > Capabilities are an important part of the MMC subsystem. Much
> > supported functionality would be lost if we didn't provide the
> > same level of support when booting Device Tree as we currently
> > do when the subsystem is passed capabilities via platform data.
> > This patch supplies this support with one simple call to a
> > DT parsing function.
> 
> We already document all the commonly used properties
> in Documentation/devicetree/bindings/mmc/mmc.txt

<snip>

> and so on. What are you actually missing in the properties that
> are already there?

MMC_CAP_ERASE
MMC_CAP_UHS_SDR12
MMC_CAP_UHS_SDR25
MMC_CAP_UHS_DDR50
MMC_CAP_1_8V_DDR

MMC_CAP2_DETECT_ON_ERR
MMC_CAP2_NO_SLEEP_CMD

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

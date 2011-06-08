Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1FHUeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:34:17 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:33396 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1FHUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:34:16 -0400
Date: Wed, 8 Jun 2011 14:34:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nikolaus Voss <n.voss@weinmann.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/rtc-m41t93: Use spi_get_drvdata() for SPI devices
Message-ID: <20110608203414.GA15006@ponder.secretlab.ca>
References: <1307562483-4883-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307562483-4883-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 09:48:03PM +0200, Geert Uytterhoeven wrote:
> One new offender detected by the recently increased type checking in
> platform_get_drvdata():
> 
> drivers/rtc/rtc-m41t93.c: In function ‘m41t93_remove’:
> drivers/rtc/rtc-m41t93.c:192: warning: passing argument 1 of ‘platform_get_drvdata’ from incompatible pointer type

Applied, thanks.

g.


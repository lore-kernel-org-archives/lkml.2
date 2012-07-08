Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2GHMK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 08:10:28 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:55399 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750798Ab2GHMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 08:10:27 -0400
Date: Sun, 8 Jul 2012 14:10:25 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog/ie6xx_wdt: section mismatch in ie6xx_wdt_probe()
Message-ID: <20120708121025.GC735@spo001.leaseweb.com>
References: <1341419531-8031-1-git-send-email-dev@snitselaar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341419531-8031-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerard,

> ie6xx_wdt_probe() calls ie6xx_wdt_debugfs_exit() as part of
> it's error cleanup path, and ie6xx_wdt_debugfs_exit() is
> currently annotated __devexit.
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Added to linux-watchdog-next.

Kind regards,
Wim.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1EVWvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:51:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36402 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755900Ab1EVWvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:51:09 -0400
Date: Mon, 23 May 2011 06:51:05 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        lrg@slimlogic.co.uk, lrg@ti.com, linux@slimlogic.co.uk,
        balajitk@ti.com
Subject: Re: [PATCH v4 2/2] USB: TWL6025 allow different regulator name
Message-ID: <20110522225103.GB15882@opensource.wolfsonmicro.com>
References: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk>
 <1306095684-7732-3-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306095684-7732-3-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 09:21:24PM +0100, Graeme Gregory wrote:
> The twl6025 uses a different regulator for USB than the 6030 so select
> the correct regulator name depending on the subclass of device.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

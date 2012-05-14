Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab2ENUMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:12:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48825 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2ENUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <1336654665-693-1-git-send-email-shubhrajyoti@ti.com>
References: <1336654665-693-1-git-send-email-shubhrajyoti@ti.com>
Date: Mon, 14 May 2012 22:12:19 +0200
Message-ID: <CACRpkdbb0pRmnN-E_M7MLZoN5c_vYNj4AWsSvv-9ZDJzh3Pbjw@mail.gmail.com>
Subject: Re: [PATCH] spi/omap2-mcspi: convert to the pump message infrastructure
From: Linus Walleij <linus.walleij@linaro.org>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 2:57 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:

> This patch converts the OMAP SPI driver to use the SPI infrastructure
> pump message queue.Also fixes the below warning.
> master is unqueued, this is deprecated
>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Final version of the patch?
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

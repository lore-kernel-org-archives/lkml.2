Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2EJOBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:01:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49644 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab2EJOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <1336657841-2306-1-git-send-email-shubhrajyoti@ti.com>
References: <1336657841-2306-1-git-send-email-shubhrajyoti@ti.com>
Date: Thu, 10 May 2012 16:01:27 +0200
Message-ID: <CACRpkdZmr+i6d+k8XU6Qxo425=mFZo5kzUe1wFk+grxDshaoVA@mail.gmail.com>
Subject: Re: [PATCH RFC] spi: Dont call prepare/unprepare transfer if not populated
From: Linus Walleij <linus.walleij@linaro.org>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 3:50 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:

> Currently the prepare/unprepare transfer are called unconditionally.
> The assumption is that every driver using the spi core queue infrastructure
> has to populate the prepare and unprepare functions. This encourages
> drivers to populate empty functions to prevent crashing.
> This patch prevents the call to prepare/unprepare if not populated.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Great!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

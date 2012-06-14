Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2FNKqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:46:20 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57890 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab2FNKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <1339669250-9183-5-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-5-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:15:55 +0530
Message-ID: <CAMQu2gydS0qFCq705pHj6jZbyqLEMmtdw1dNYAezBowpxbk9Ow@mail.gmail.com>
Subject: Re: [PATCH 04/17] i2c: omap: simplify omap_i2c_ack_stat()
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> stat & BIT(1) is the same as BIT(1), so let's
> simplify things a bit by removing "stat &" from
> all omap_i2c_ack_stat() calls.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
Indeed. Looks good to me.
Reviewed-by : Santosh Shilimkar <santosh.shilimkar@ti.com>

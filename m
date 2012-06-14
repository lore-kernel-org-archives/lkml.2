Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab2FNLEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:04:04 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:34392 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225Ab2FNLEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:04:01 -0400
MIME-Version: 1.0
In-Reply-To: <1339669250-9183-9-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-9-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:33:39 +0530
Message-ID: <CAMQu2gw-rX9Xq7PPU9sGB=EFd4f3xfsPPDdODRyU5Jwg20v4GQ@mail.gmail.com>
Subject: Re: [PATCH 08/17] i2c: omap: switch over to do {} while loop
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
> this will make sure that we execute at least once.
> No functional changes otherwise.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
Executing at least once instead of never is
still a functional change :-)

Regards
Santosh

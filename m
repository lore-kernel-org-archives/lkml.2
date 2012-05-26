Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2EZRXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 13:23:05 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:39467 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab2EZRXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 13:23:03 -0400
MIME-Version: 1.0
In-Reply-To: <1337414319-27719-1-git-send-email-santosh.shilimkar@ti.com>
References: <1337414319-27719-1-git-send-email-santosh.shilimkar@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sat, 26 May 2012 22:52:40 +0530
Message-ID: <CAMQu2gwkcVXAp1iThQRn3Ff-AH33aM9CayJO6TQ109kdX=a0_w@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Fix build warning with !CONFIG_SUSPEND
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Sat, May 19, 2012 at 1:28 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> With !CONFIG_SUSPEND, mmc core layer throws below build warnings.
>
> drivers/mmc/core/bus.c:125: warning: 'mmc_bus_suspend' defined but not used
> drivers/mmc/core/bus.c:136: warning: 'mmc_bus_resume' defined but not used
> drivers/mmc/core/sdio_bus.c:197: warning: 'pm_no_operation' defined but not used
>
> Fix is by wrapping suspend hooks under CONFIG_SUSPEND
>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Chris Ball <cjb@laptop.org>
> ---
Ping

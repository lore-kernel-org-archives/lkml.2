Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2IQEWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:22:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63385 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2IQEWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <1347524542-4569-2-git-send-email-haojian.zhuang@gmail.com>
References: <1347524542-4569-1-git-send-email-haojian.zhuang@gmail.com>
	<1347524542-4569-2-git-send-email-haojian.zhuang@gmail.com>
Date: Mon, 17 Sep 2012 12:22:22 +0800
Message-ID: <CAN1soZz3HgwX8s31D8EozVydCkYvsv4UdfkHs+bumrJgGfmXwQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mfd: max8925: use register offset as REG in backlight
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 4:22 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> Remove the register offset definition. All these register offset
> are transfered as IORESOURCE_REG resources.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/mfd/max8925-core.c           |   31 ++++++-------
>  drivers/video/backlight/max8925_bl.c |   79 ++++++++++++++++++----------------
>  2 files changed, 55 insertions(+), 55 deletions(-)

Please ignore this patch series. New version of these two patches are
included and sent
in another mail loop.

Regards
Haojian

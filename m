Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2KHVYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:24:05 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63359 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2KHVYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:24:02 -0500
MIME-Version: 1.0
In-Reply-To: <1352300492-24779-2-git-send-email-ldewangan@nvidia.com>
References: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com>
	<1352300492-24779-2-git-send-email-ldewangan@nvidia.com>
Date: Thu, 8 Nov 2012 22:24:01 +0100
Message-ID: <CACRpkdYm283wr6Si4qcGw5LxCnEWrnT2xPqHfJCPonL7tCcLMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: tegra: fix suspend/resume apis
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 4:01 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Following are changes done to fix the suspend/resume
> functionality of tegra gpio driver:
> - Protect suspend/resume callbacks with CONFIG_PM_SLEEP
>   because CONFIG_PM doesn't actually enable any of the PM callbacks, it
>   only allows to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
>   This means if CONFIG_PM is used to protect system sleep callbacks
>   then it may end up unreferenced if only runtime PM is enabled.
>
> - Fix the suspend/resume APIs declaration as per callback prototype.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

OK patch applied to my devel branch, with Stephens ACK
and I also fixed the whitespace issue he pointed out.

Yours,
Linus Walleij

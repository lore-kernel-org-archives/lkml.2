Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2GJLdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:33:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39014 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2GJLdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:33:52 -0400
MIME-Version: 1.0
In-Reply-To: <1341919244-23327-2-git-send-email-ldewangan@nvidia.com>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
	<1341919244-23327-2-git-send-email-ldewangan@nvidia.com>
Date: Tue, 10 Jul 2012 17:03:51 +0530
Message-ID: <CAM=Q2ctEijbh5dPRKHMBPaSupSkZSN0J36hpYBbd4Xb+-O6DCQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] i2c: tegra: remove unused member variable
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: w.sang@pengutronix.de, khali@linux-fr.org, ben-linux@fluff.org,
        swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Tue, Jul 10, 2012 at 4:50 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Remove unused member variable "iomem" of the
> i2c device structure.

You might want to mention the commit which removed the last usage etc.

>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> This patch is resend of earlier patch
>  i2c: tegra: remove unused member variable.
> and sending it as part fo series.
>

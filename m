Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2KHVZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:25:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51571 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab2KHVZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:25:13 -0500
MIME-Version: 1.0
In-Reply-To: <1352348544-24416-1-git-send-email-ldewangan@nvidia.com>
References: <1352348544-24416-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 8 Nov 2012 22:25:10 +0100
Message-ID: <CACRpkdYZLa4U0GfzqQYmT9eRG6bC9=XY6cQe0De2EwXcRz-UOw@mail.gmail.com>
Subject: Re: [PATCH V2] gpio: tegra: fix suspend/resume apis
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 5:22 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Changes from V1:
> - It was 2/2/ for prev patch and dropping 1/2.
> - nit cleanup in change.
> - Added ack from Stephen as it is acked in 2/2.

Oh I didn't see you respun it yourself. Anyway it's applied now.

Yours,
Linus Walleij

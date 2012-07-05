Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab2GENE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:04:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54363 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab2GENEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <1340181845-14582-1-git-send-email-ldewangan@nvidia.com>
References: <1340181845-14582-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 5 Jul 2012 15:04:50 +0200
Message-ID: <CACRpkdaWVthuH-bMj=b1PxHY8F2o+PqeYSLmndWup7u=Etz63g@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: fix bits conflict for gpio flags
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:44 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The bit 2 and 3 in GPIO flag are allocated for the
> flag OPEN_DRAIN/OPEN_SOURCE. These bits are reused
> for the flag EXPORT/EXPORT_CHANGEABLE and so creating
> conflict.
> Fix this conflict by assigning bit 4 and 5 for the
> flag EXPORT/EXPORT_CHANGEABLE.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Resending this patch in case of if previous patch lost.

Applied.

Thanks,
Linus Walleij

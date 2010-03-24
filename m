Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0CXWhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:37:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53362 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0CXWhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qdYwwQQ4QqYx8xcV1O1HxrWfDrFKr3n84Yu2FvRbVTXZ/3fkLw1FWYJJIPkBwFjAWx
         gfw92AxQKuLFBAC8S0T5wm6Ay/xAbZmVHSs0TIMYYXqp3Lq1xMNKpVQVtyAvYBhjDaxR
         QhStTPPad6KqeQzOycurPz+xhEuxZlwWk518U=
MIME-Version: 1.0
In-Reply-To: <1268473365-30197-1-git-send-email-linus.walleij@stericsson.com>
References: <1268473365-30197-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 24 Mar 2010 15:37:13 -0700
X-Google-Sender-Auth: 9422ad07666e0e4d
Message-ID: <e9c3a7c21003241537j1fc2cb4cjfbea205b904ec852@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: U300 platform configuration
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 2:42 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This completes the DMA40 support with the platform-specific
> configuration for U8500/DB8500.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  arch/arm/mach-ux500/board-mop500.c           |  222 +++++++++++++++++++++
>  arch/arm/mach-ux500/clock.c                  |    4 +-
>  arch/arm/mach-ux500/include/mach/hardware.h  |   16 ++-
>  arch/arm/mach-ux500/include/mach/ste_dma40.h |  268 ++++++++++++++++++++++++++
>  arch/arm/mach-ux500/ste-dma40-db8500.h       |  133 +++++++++++++
>  5 files changed, 640 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/mach-ux500/include/mach/ste_dma40.h

Quick comment, this file needs to be moved into the first patch
otherwise there is bisection/build breakage.

drivers/dma/ste_dma40.c:17:28: error: mach/ste_dma40.h: No such file
or directory

--
Dan

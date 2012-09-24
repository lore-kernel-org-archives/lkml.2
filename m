Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab2IXWEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:04:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42025 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2IXWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:04:49 -0400
MIME-Version: 1.0
In-Reply-To: <1348512893-1375-1-git-send-email-selso.liberado@gmail.com>
References: <1348512893-1375-1-git-send-email-selso.liberado@gmail.com>
Date: Mon, 24 Sep 2012 17:04:49 -0500
Message-ID: <CAJ6Av5Pq6ZnxVReQsLUt2Zpari9aRHHbZF+sA5zZwXg-AC0LrA@mail.gmail.com>
Subject: Re: [PATCH 1/2] The tidspbridge driver does not compile anymore (Some
 OMAP34XX CPU definitions are missing). I Added a header file for these definitions.
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: selso <selso.liberado@gmail.com>
Cc: omar.ramirez@ti.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 24, 2012 at 1:54 PM, selso <selso.liberado@gmail.com> wrote:
> From: sli <sli@SLI-V420.(none)>
>
>
> Signed-off-by: sli <sli@SLI-V420.(none)>
> ---
>  drivers/staging/tidspbridge/core/dsp-clock.c       |    3 ++
>  drivers/staging/tidspbridge/core/tiomap3430.c      |    4 ++
>  drivers/staging/tidspbridge/core/wdt.c             |    2 +-
>  .../tidspbridge/include/dspbridge/omap34xx.h       |   33 ++++++++++++++++++++
>  4 files changed, 41 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/staging/tidspbridge/include/dspbridge/omap34xx.h

This is fixed with this patch:

https://patchwork.kernel.org/patch/1435311/

Thanks,

Omar

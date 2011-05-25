Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab1EYMjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:39:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46237 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1EYMjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:39:48 -0400
MIME-Version: 1.0
In-Reply-To: <1306323570-11133-3-git-send-email-vinod.koul@intel.com>
References: <1306323570-11133-1-git-send-email-vinod.koul@intel.com>
	<1306323570-11133-3-git-send-email-vinod.koul@intel.com>
Date: Wed, 25 May 2011 14:39:47 +0200
Message-ID: <BANLkTikV3qT7owEuLmsGu+ORMNv77DgXSQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dmaengine: add TODO items for future work on dma drivers
From: Per Forlin <per.forlin@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 May 2011 13:39, Koul, Vinod <vinod.koul@intel.com> wrote:
> From: Vinod Koul <vinod.koul@intel.com>
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
>  drivers/dma/TODO |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/TODO
>
> diff --git a/drivers/dma/TODO b/drivers/dma/TODO
> new file mode 100644
> index 0000000..b67d184
> --- /dev/null
> +++ b/drivers/dma/TODO
> @@ -0,0 +1,12 @@
> +TODO for slave dma
> +
> +1. Move remaining drivers to use new slave interface
> +2. Remove old slave pointer machansim
> +3. Make issue_pending to start the transaction in below drivers
> +       - mpc512x_dma
> +       - imx-dma
> +       - imx-sdma
> +       - mxs-dma.c
> +       - dw_dmac
> +       - intel_mid_dma
> +       - ste_dma40
ste_dma40 already does this. At least is does so in 2.6.39. I may not
be up to date of what is merged for 2.6.40.

/Per

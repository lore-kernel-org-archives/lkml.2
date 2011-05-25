Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1EYMro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:47:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38649 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab1EYMro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H7TZIl26jA+nNa2cnQvkl+6U6ww45Mg1WzVG0qXV2ZPUgPORCYbG1C8C5AX5aFmjke
         GRbvFdmii81Om2BOCHNW1m9WXXBMi07xjnMIPHqHv7Q7gBOh6Bj/nggJa5UabdiPVOBg
         dRd5PsWWPUIAA+NadDme6P+UGD+fvflPX57qs=
MIME-Version: 1.0
In-Reply-To: <1306323570-11133-3-git-send-email-vinod.koul@intel.com>
References: <1306323570-11133-1-git-send-email-vinod.koul@intel.com>
	<1306323570-11133-3-git-send-email-vinod.koul@intel.com>
Date: Wed, 25 May 2011 14:47:43 +0200
X-Google-Sender-Auth: VlNlqR21Q7aKFAKf5aCC5ROOVJg
Message-ID: <BANLkTinP-5z0ecf0zvrEnLOSDvOhLzMKDw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dmaengine: add TODO items for future work on dma drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Per Forlin <per.forlin@linaro.org>, Dan <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 Koul, Vinod <vinod.koul@intel.com>:

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

Here is the hitlist:
- find arch/arm/ |grep -e "dma.c$"
- arch/arm/mach-s3c64xx/dma.c need to be merged into
  drivers/dma/amba-pl08x.c - make adjustments for local
  deviations

Or were you mainly talking about the drivers already in
drivers/dma?

Linus Walleij

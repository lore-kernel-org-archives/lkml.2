Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2EBSKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:10:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55228 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2EBSKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:10:45 -0400
MIME-Version: 1.0
X-Originating-IP: [172.22.162.26]
In-Reply-To: <1335935266-25289-5-git-send-email-thomas.abraham@linaro.org>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-5-git-send-email-thomas.abraham@linaro.org>
Date: Wed, 2 May 2012 11:10:45 -0700
Message-ID: <CAOesGMiJrfCgLHmBix1WUrpF-0D9tG5r6xi-3zsiM7KQjkO=ug@mail.gmail.com>
Subject: Re: [PATCH 4/7] mmc: dw_mmc: add samsung exynos5250 specific extentions
From: Olof Johansson <olof@lixom.net>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 1, 2012 at 10:07 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> The instantiation of the Synopsis Designware controller on Exynos5250
> include extension for SDR and DDR specific tx/rx phase shift timing
> and CIU internal divider. In addition to that, the option to skip the
> command hold stage is also introduced. Add support for these Exynos5250
> specfic extenstions.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |   33 +++++++++++++++++++-
>  drivers/mmc/host/dw_mmc-pltfm.c                    |    8 +++++
>  drivers/mmc/host/dw_mmc.c                          |   32 ++++++++++++++++++-
>  drivers/mmc/host/dw_mmc.h                          |   13 ++++++++
>  include/linux/mmc/dw_mmc.h                         |    6 +++
>  5 files changed, 89 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
> index c1ed70e..465fc31 100644
> --- a/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
> @@ -7,6 +7,8 @@ Required Properties:
>
>  * compatible: should be one of the following
>        - synopsis,dw-mshc: for controllers compliant with synopsis dw-mshc.
> +       - synopsis,dw-mshc-exynos5250: for controllers with Samsung
> +         Exynos5250 specific extentions.

It makes more sense to use your own manufacturer prefix here:

samsung,exynos5250-dw-mshc


-Olof

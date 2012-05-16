Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab2EPGfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:35:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46827 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564Ab2EPGfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:35:03 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1336635764-30597-2-git-send-email-hdoyu@nvidia.com>
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
	<1336635764-30597-2-git-send-email-hdoyu@nvidia.com>
Date: Tue, 15 May 2012 23:35:02 -0700
Message-ID: <CAOesGMiPvw72006zpSGLBNi-C12MTc_w2QmOPg6YTfXMW+ZSkQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: dt: tegra20.dtsi: Add Memory Controller(MC) nodes
From: Olof Johansson <olof@lixom.net>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Glass <sjg@chromium.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tiny drive-by nit pick.

On Thu, May 10, 2012 at 12:42 AM, Hiroshi DOYU <hdoyu@nvidia.com> wrote:
> Add Tegra MC(Memory Controller) nodes for tegra20.dtsi.
>
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra20.dtsi |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 24129fb..548b42e 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -211,5 +211,12 @@
>                compatible = "nvidia,tegra20-ahb";
>                reg = <0x6000c004 0x10c>; /* AHB Arbitration + Gizmo Controller */
>        };
> +
> +       mc {

It's common to use a more plain english name here, so
"memory-controller" would be a good name.



-Olof

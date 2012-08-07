Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2HGTie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:38:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2HGTid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:38:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dongjin Kim <tobetter@gmail.com>
Subject: Re: [PATCH 2/4] arm/dts: exynos4: Add DTS files derived from common Exynos4
Date: Tue, 7 Aug 2012 19:38:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1344366398-19022-1-git-send-email-dongjin.kim@agreeyamobility.net>
In-Reply-To: <1344366398-19022-1-git-send-email-dongjin.kim@agreeyamobility.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208071938.26507.arnd@arndb.de>
X-Provags-ID: V02:K0:GVcoHtmQIzXktu+fbfKT2htmHV/YdGemDzothW90DR1
 BCEpcedTgy9IxqHw8iNNe/oQfqsiu4RXV1ewsmpjxW7pRusohg
 4e6ieOcfEjhCyt85qHVVlkl1w0zzrpEK2NTlpjHsgg/9jd4Uz6
 jUyntgKa4Ls6yn68NDQ572fAOyPlGYcJS23LtUaDLAyBW9tIx5
 HzOPVALW3MyzUxLFKnw4LjQwbQWcWS5GPpdUtY/W3fSwE10Qe9
 dSWUeZznYjEPbrvbbp3c7/64rHxOc3jWJl2Rw1yGeaHwrpbQS0
 MVD/uqCTYnAQyu6fnwIcPWvwaEgGqLB/pi4dsFES6laLdu5yOM
 hmy6vT9UTlw33AwJ+G04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012, Dongjin Kim wrote:
> 
> This patch creates a DTS file, exynos4.dtsi, for Exynos4210/4x12 and it
> describes common device nodes. SoC specific device nodes are described in
> another DTS file derived from this, exynos4210.dtsi and exynos4412.dtsi.
> 
> exynos4412.dtsi is added new for Exynos4412 as well as exynos4210 is modified
> for Exynos4210 specific device nodes.
> 
> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> ---
>  arch/arm/boot/dts/exynos4.dtsi    |  404 +++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos4210.dtsi |  374 +---------------------------------
>  arch/arm/boot/dts/exynos4412.dtsi |  104 ++++++++++
>  3 files changed, 510 insertions(+), 372 deletions(-)

Looks good in principle. I would hope that "git format-patch -M" can detect this
mostly-moved filed. Did you use that?

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767687Ab2KOMXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:23:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767581Ab2KOMXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:23:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/1] ARM: ux500: Describe UART platform registering issues more accurately
Date: Thu, 15 Nov 2012 12:23:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Jon Hunter <jon-hunter@ti.com>
References: <1352968401-6092-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1352968401-6092-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151223.46989.arnd@arndb.de>
X-Provags-ID: V02:K0:SqJn67KnBsYp2VMSAwkq4wQvwlo61/XYGEQ2HNsBK1i
 Ks0QOHRIJlzJLPEOfEyX0f6TePIMgtjhrxszYoH4LVEJzuc+CI
 3fSiBYsvhFFmixEqxj2XT17G9/lWQlg/U0PyG85cCd+0WAQ/D0
 81/Vj/2SYpRzdxELHXQIEGl1yMoOeV6DyeOYxQVjN8RD1a0MBA
 Es1wPfrxVwyvax1lCI8jI8JuBpkT6fJdeyXHnessJ6CI05qQC0
 MlJHn1ssDIjPmApejRUpyW9zqYHG+cNMeuQO0WA/c+ScdnXjz7
 UlGIQQzcN8i4JUVFboZhINmWlLSc2Ro5b/C7xUxPqI7Haicd+o
 ng7yP7NO8SdXQafxTVUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Lee Jones wrote:
> UARTs no longer require call-back information, since the reset
> call-back was removed in 43b5f0d69291374f602ad8e1817f329573a59010.
> The only AUXDATA dependencies remaining for UARTs are DMA settings.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

What is the state of the DMA binding now? We originally wanted to merge
it for 3.7, but that didn't work out, so I hope we can get it done for
3.8.

	Arnd

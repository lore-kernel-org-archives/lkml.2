Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2JCISK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:18:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46384 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab2JCISH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:18:07 -0400
Message-ID: <506BF4B6.8090701@ti.com>
Date: Wed, 3 Oct 2012 13:47:58 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.lad@ti.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH v3 0/2] ARM: davinci: da850/omap-l138: add support for
 VPIF driver
References: <1347344709-6180-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1347344709-6180-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 9/11/2012 11:55 AM, Prabhakar Lad wrote:
> This patch series adds support for VPIF
> capture and display driver on da850/omap-l138.
> Enables SD capture and display.
> 
> This patch series is dependent on the following patch:
> https://patchwork.kernel.org/patch/1332311/
> 
> Changes for v3:
> 1: Clubbed the code for DA850_UI_SD_VIDEO_PORT config
>    as pointed by Sekhar.
> 2: Define  the resource structure outside the function as pointed
>    by Sekhar.
> 
> Changes for v2:
> 1: Avoid breaking of print messages.
> 2: Removed the handlers which just returned zero (which did nothing).
> 3: Clubbed the code where ever possible for DA850_UI_SD_VIDEO_PORT
>    config option.
> 4: Removed the dma_declare_coherent_memory() calls and used
>    global CMA.
> 5: Added the base address in increasing order.
> 
> Manjunath Hadli (2):
>   ARM: da850/omap-l138: Add SoC related definitions for VPIF
>   ARM: da850/omap-l138: Add EVM specific code for VPIF to work
> 
> Manjunath Hadli (2):
>   ARM: da850/omap-l138: Add SoC related definitions for VPIF
>   ARM: da850/omap-l138: Add EVM specific code for VPIF to work
> 
>  arch/arm/mach-davinci/Kconfig              |    7 ++
>  arch/arm/mach-davinci/board-da850-evm.c    |  156 ++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/da850.c              |  152 +++++++++++++++++++++++++++
>  arch/arm/mach-davinci/include/mach/da8xx.h |   11 ++
>  arch/arm/mach-davinci/include/mach/mux.h   |   42 ++++++++
>  arch/arm/mach-davinci/include/mach/psc.h   |    1 +
>  6 files changed, 369 insertions(+), 0 deletions(-)

The patches look good to me. In case you want to queue them through the
media tree to manage the dependencies, feel free to add my:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Note that the subject like prefix for DA850 soc patches should be

"ARM: davinci: da850: .."

and that for DA850 EVM patches should be:

"ARM: davinci: da850 evm: .."

instead of what you have used here. Please fix these if you are queuing
them and take care of this in future.

Thanks,
Sekhar

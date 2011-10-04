Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1JDQPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:15:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55369 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1JDQPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:15:09 -0400
Message-ID: <4E8B3109.2020705@gmail.com>
Date: Tue, 04 Oct 2011 11:15:05 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: grant.likely@secretlab.ca
CC: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org
Subject: Re: [PATCH 0/3] GIC OF bindings
References: <1317410880-24828-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1317410880-24828-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 09/30/2011 02:27 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Another round of GIC devicetree support.
> 
> This moves the tracking of the starting hwirq number into the irq domain
> code. Doing this makes hwirq == GIC interrupt ID and simplifies the GIC
> code removing irq_offset.
> 
> The full series is available here. This includes Russell's devel-stable and
> for-next branches and Nico's vmalloc branch:
> 
> git://git.jdl.com/software/linux-3.0.git gic-v2
> 
> Tested on highbank and Realview 11MPCore qemu (2 GICs).
> 
> Rob
> 
> Rob Herring (3):
>   irq: support domains with non-zero hwirq base
>   ARM: gic: add irq_domain support
>   ARM: gic: add OF based initialization
> 
>  Documentation/devicetree/bindings/arm/gic.txt |   55 ++++++++++
>  arch/arm/common/Kconfig                       |    1 +
>  arch/arm/common/gic.c                         |  142 +++++++++++++++++++------
>  arch/arm/include/asm/hardware/gic.h           |    5 +-
>  include/linux/irqdomain.h                     |   16 +++-
>  kernel/irq/irqdomain.c                        |   12 +-
>  6 files changed, 189 insertions(+), 42 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
> 

Ping. Can you please comment on this series.

Rob

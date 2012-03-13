Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab2CMWyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:54:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42969 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484Ab2CMWyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:54:51 -0400
Message-ID: <4F5FD037.5000703@gmail.com>
Date: Tue, 13 Mar 2012 17:54:47 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PULL] generic irq chip and pl061 irqdomain support
References: <4F3ADFE7.4090409@gmail.com> <4F5437FE.2000306@gmail.com>
In-Reply-To: <4F5437FE.2000306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2012 09:50 PM, Rob Herring wrote:
> Grant,
> 
> On 02/14/2012 04:27 PM, Rob Herring wrote:
>> Grant,
>>
>> Please pull. This is based on your current branch which you have said
>> you plan to rebase, so feel free to rebase these as you need to. This
>> has been tested on highbank and i.MX5.
>>
> 
> Ping.
> 
> I've rebased onto your current tree. Updated pull request:
> 
> The following changes since commit 280ad7fda5f95211857fda38960f2b6fdf6edd3e:
> 
>   mfd: twl-core: Add IRQ_DOMAIN dependency (2012-02-26 16:48:06 -0700)
> 
> are available in the git repository at:
>   git://sources.calxeda.com/kernel/linux.git irqdomain-for-grant
> 
> Rob Herring (3):
>       ARM: kconfig: always select IRQ_DOMAIN
>       irq: add irq_domain support to generic-chip
>       gpio: pl061: enable interrupts with DT style binding
> 
>  .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++
>  arch/arm/Kconfig                                   |    2 +-
>  arch/arm/common/Kconfig                            |    2 -
>  drivers/gpio/gpio-pl061.c                          |   48 ++++---
>  include/linux/irq.h                                |   15 ++
>  kernel/irq/generic-chip.c                          |  152
> +++++++++++++++++---
>  6 files changed, 186 insertions(+), 48 deletions(-)
> 

Ping again...

Rob

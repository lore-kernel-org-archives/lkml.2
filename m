Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1KOAxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:53:37 -0500
Received: from mail2.unitix.de ([176.9.2.175]:56528 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1KOAxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:53:36 -0500
Message-ID: <4EC1B80D.5000102@arndnet.de>
Date: Tue, 15 Nov 2011 01:53:33 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dwmw2@infradead.org, iommu@lists.linux-foundation.org
Subject: Re: 3.2rc1: bootup fails: DRHD: handling fault status reg 2
References: <4EC19738.8050007@arndnet.de>
In-Reply-To: <4EC19738.8050007@arndnet.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 14.11.2011 23:33, schrieb Arnd Hannemann:

> when trying to boot kernel 3.2rc1 on my thinkpad t510 I get an endless loop of errors:
> 
>  DRHD: handling fault status reg 2
>  DMAR: [DMA Read] Request device [0d:00.0] fault addr fffff000
>  DMAR: [fault reason 02] Present bit in context entry is clear
> 
> screenshot can be found here:
> http://arndnet.de/lkml/screenshot3.2rc1.jpg
> 
> kernel 3.1.1 is booting up flawlessly.

I must have inadvertently enabled CONFIG_INTEL_IOMMU_DEFAULT_ON in my config
for 3.2-rc1.

With disabled CONFIG_INTEL_IOMMU_DEFAULT_ON my thinkpad boots up again.
Not sure if this is expected?

Best regards
Arnd

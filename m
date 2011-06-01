Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1FBFsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:48:03 -0400
Received: from c-67-188-111-120.hsd1.ca.comcast.net ([67.188.111.120]:49401
	"EHLO saboo.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080Ab1FBFsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:48:01 -0400
Message-ID: <4DE6CC6C.7000703@goop.org>
Date: Wed, 01 Jun 2011 16:34:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: NetDev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: 3.0-rc1: DMAR errors from iwlagn
References: <4DE55A26.6040702@goop.org>
In-Reply-To: <4DE55A26.6040702@goop.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: linux-wireless

On 05/31/2011 02:14 PM, Jeremy Fitzhardinge wrote:
> I have a Lenovo X220 with:
>
> 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
> 	Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN
> 	Flags: bus master, fast devsel, latency 0, IRQ 50
> 	Memory at d2500000 (64-bit, non-prefetchable) [size=8K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: iwlagn
> 	Kernel modules: iwlagn
>
> With 3.0-rc1, I'm seeing these in dmesg:
>
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [03:00.0] fault addr ffe8a000 
> DMAR:[fault reason 05] PTE Write access is not set
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [03:00.0] fault addr ffd5a000 
> DMAR:[fault reason 05] PTE Write access is not set
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [03:00.0] fault addr ffd52000 
> DMAR:[fault reason 05] PTE Write access is not set
>
> but the device seems to be working OK.
>
> Thanks,
> 	J
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


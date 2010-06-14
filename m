Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0FNI2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:28:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46438 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab0FNI2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:28:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C15E7F4.9090607@jp.fujitsu.com>
Date: Mon, 14 Jun 2010 17:27:32 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFC0.1030006@jp.fujitsu.com> <4C1275BF.3070605@zytor.com> <4C158BCF.6000303@jp.fujitsu.com>
In-Reply-To: <4C158BCF.6000303@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you mean x86 linux can map physical address higher than 36-bit for I/O?
> My understanding is as follows.
> - Architectural limit of physical address in x86 32-bit mode is 40-bit
> (depnds on processor version).
> - The maximum physical address supported by current x86 linux kernel in
> 32-bit mode is 36-bit.
> On my environment, physical address higher than 40-bit (ex. 0xfc00001c000)
> is assigned to some PCI devices. I think there is no way to handle such
> high physical address in 32-bit mode.
>
> Thanks,
> Kenji Kaneshige

Please ignore above. I misunderstood the architectural limit of physical
address in x86 32-bit mode. It is not 40-bits, but 52-bits.

Thanks,
Kenji Kaneshige


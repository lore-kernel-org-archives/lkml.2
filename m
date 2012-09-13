Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2IMOfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:35:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46719 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2IMOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:35:45 -0400
Message-ID: <5051EF3C.3020401@lwfinger.net>
Date: Thu, 13 Sep 2012 09:35:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: rtl8192se: ping router gives mdev of 25387.102???
References: <20120913101828.GA3309@gandalf.dynalias.org>
In-Reply-To: <20120913101828.GA3309@gandalf.dynalias.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 05:18 AM, Norbert Preining wrote:
> Hi everyone,
>
> (please cc)
>
> see $subject ...
>
> No warning, nothing in the logs, but pinging my router I get
> things like:
> --- 192.168.0.1 ping statistics ---
> 376 packets transmitted, 315 received, +33 errors, 16% packet loss, time 405164ms
> rtt min/avg/max/mdev = 0.873/10077.793/95935.698/25387.102 ms, pipe 68
>
> or
> --- 192.168.0.1 ping statistics ---
> 1252 packets transmitted, 1225 received, 2% packet loss, time 1252976ms
> rtt min/avg/max/mdev = 0.941/764.171/19929.265/2758.225 ms, pipe 20
>
>
> Has anyone *ever* seen a mdev of 25387.102 ms ???
>
> At the same time I am pinging the same router from an iphone with a
> steady stream of 40ms or so, no problem whatsoever ...
>
> $ lspci -v -s 03:00.0
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller (rev 10)
> 	Subsystem: Realtek Semiconductor Co., Ltd. Device e020
> 	Flags: bus master, fast devsel, latency 0, IRQ 17
>   	I/O ports at 2000 [size=256]
>   	Memory at f0500000 (32-bit, non-prefetchable) [size=16K]
>   	Capabilities: [40] Power Management version 3
>   	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>   	Capabilities: [70] Express Legacy Endpoint, MSI 00
>   	Capabilities: [100] Advanced Error Reporting
>   	Capabilities: [140] Virtual Channel
>   	Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
>   	Kernel driver in use: rtl8192se

When you post the output of lspci, always include the -nn or -nnv switches. That 
way, we get the PCI ID. As there are several varieties of the RTL8192SE, I need 
that info. In addition, what are the details of your AP - STA configuration. 
What is the distance? Is it 802.11n or 802.11g? What is the signal strength as 
indicated by iwconfig or a scan?

Larry


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab2CGR1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:27:39 -0500
Received: from nbd.name ([46.4.11.11]:41390 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab2CGR1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:27:38 -0500
Message-ID: <4F579A88.6030503@openwrt.org>
Date: Wed, 07 Mar 2012 18:27:36 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>, linux-kernel@vger.kernel.org,
        Linux-netdev <netdev@vger.kernel.org>,
        Linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
 DMADBG_7=0x00008040
References: <4F576FD5.2050208@gmail.com> <CAD2nsn23UqshHz1ZUn8bHN0rWyOMbBHhn9V8pmCc4_aT_uGYaw@mail.gmail.com> <4F577D9B.7020402@gmail.com>
In-Reply-To: <4F577D9B.7020402@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-07 4:24 PM, Justin P. Mattock wrote:
> On 03/07/2012 07:19 AM, Mohammed Shafi wrote:
>> On Wed, Mar 7, 2012 at 7:55 PM, Justin P. Mattock
>> <justinmattock@gmail.com>  wrote:
>>> ath9k craps out from time to time(more annoying if anything)
>>>
>>> [44309.840830] ath: Failed to stop TX DMA, queues=0x001!
>>> [44309.858246] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
>>> AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
>>> [44309.858255] ath: Could not stop RX, we could be confusing the DMA engine
>>> when we start RX up
>>> [44309.932801] ath: Failed to stop TX DMA, queues=0x001!
>>> [44309.950352] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
>>> AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
>>> [44309.950361] ath: Could not stop RX, we could be confusing the DMA engine
>>> when we start RX up
>>> [44310.024301] ath: Failed to stop TX DMA, queues=0x001!
>>> [44310.041641] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
>>> AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
>>> [44310.041646] ath: Could not stop RX, we could be confusing the DMA engine
>>> when we start RX up
>>> [44310.116316] ath: Failed to stop TX DMA, queues=0x001!
>>> [44310.133909] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
>>> AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
>>> [44310.133918] ath: Could not stop RX, we could be confusing the DMA engine
>>> when we start RX up
>>> [44310.208021] ath: Failed to stop TX DMA, queues=0x001!
>>> [44310.225752] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
>>> AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
>>> [44310.225761] ath: Could not stop RX, we could be confusing the DMA engine
>>> when we start RX up
>>> [44310.299922] ath: Failed to stop TX DMA, queues=0x001!
>>> [44310.317579] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
>>> AR_DIAG_SW=0x02000020 DMADBG_7=0x00006040
>>> [44310.317587] ath: Could not stop RX, we could be confusing the DMA engine
>>> whe
>>
>> this is has become a know issue but less harmful, please try to see if
>> the workaround of disabling power save helps
>>
>> iw dev wlanX set power_save off
>>
> 
> ok! I have set that on the machine.. will see if I get this message in 
> the upcoming weeks.
Also, please try this patch with powersave enabled:
http://nbd.name/ps-fix.patch

- Felix

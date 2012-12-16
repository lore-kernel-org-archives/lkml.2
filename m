Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2LPPdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 10:33:39 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53843 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629Ab2LPPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 10:33:38 -0500
X-Sasl-enc: QR6UACPmqNvmC8+g2LQBYMayvHYCdqBqulnNnjJKVexH 1355672014
Message-ID: <50CDE9CD.5050309@itwm.fraunhofer.de>
Date: Sun, 16 Dec 2012 16:33:33 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [regression] 3.7 ends in APIC panic
References: <50CB3EAB.309@itwm.fraunhofer.de> <20121216113505.GA25304@gmail.com>
In-Reply-To: <20121216113505.GA25304@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 12:35 PM, Ingo Molnar wrote:
> 
> * Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> wrote:
> 
>> On 12/13/2012 01:16 PM, Bernd Schubert wrote:
>>> Hello,
>>>
>>> I just tried to boot 3.7 and it ends in an APIC panic. I 
>>> tried to use the recommended "apic=debug", but that does not 
>>> change anything in the output, at least not in the visible 
>>> part. The last known kernel to boot was 3.5. If it matters I 
>>> can try to boot 3.6.
>>
>> So linux-3.6 also boots. Any idea what is going on or do I 
>> really need to bisect?
> 
> Yeah, it's hard to tell based on that info alone - would be nice 
> to send in a log/screen capture of the crash and of course 
> bisecting would be useful as well, if the crash is 
> deterministic.

I already sent a screen capture in my first mail, but now uploaded two
pictures here:

http://www.aakef.fastmail.fm/linux/

I think the 2nd one is with apic=debug.

Unfortunately the system does not have ipmi, which would allow me to do
the bisecting now. It is also my desktop system at work and I don't know
yet when (and if at all) I will find the time to do the reboot cycles.


Cheers,
Bernd



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1G0WLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:11:35 -0400
Received: from c60.cesmail.net ([216.154.195.49]:18145 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1G0WLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:11:32 -0400
Message-ID: <4E308D11.8070405@gnu.org>
Date: Wed, 27 Jul 2011 18:11:29 -0400
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hostap_cs: add ID for LG cards
References: <201107262314.03422.linux@rainbow-software.org> <4E2F379D.9080108@gnu.org> <201107272219.23501.linux@rainbow-software.org>
In-Reply-To: <201107272219.23501.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 04:19 PM, Ondrej Zary wrote:
> On Tuesday 26 July 2011 23:54:37 Pavel Roskin wrote:

>> I think we may want to introduce PCMCIA_DEVICE_MANF_CARD_PROD_ID3 and match
>>
>> PCMCIA_DEVICE_MANF_CARD_PROD_ID3(0x0156, 0x0002, "Version 1.02", xxx)
>>
>> Maybe some other card would be supported too?  I doubt there are any
>> Agere or Symbol cards with "Version 1.02" in the third text ID.
>
> Yes, that looks good, it would match my card too:
>    product info: "LG", "11Mbps Wireless LAN PCI Card", "Version 01.02", ""
>    manfid: 0x0156, 0x0002
>    function: 6 (network)

Good to know.

> ---------------------------
>
> Add generic "Version 01.02" match (used by many different cards) to hostap_cs.
>
> This allows LG LW1100P PCI card (with integrated CardBus bridge) to work
> (tested with rev 3.0) and probably also LW1100N (PCMCIA).
>
> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>

That's not the right way to submit patches.  Anyway, I sent 3 patches to 
that effect yesterday.  One in for PCMCIA, the second is for hostap_cs 
and the third is for orinoco_cs to recognize "Version 01.01" as Agere 
firmware and to stop claiming 0x0156:0x0002 unconditionally.

I have no idea how interdependent series of patches that touch more than 
one subsystem are applied, but I guess there is a standard way.

-- 
Regards,
Pavel Roskin

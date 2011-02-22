Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1BVOqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:46:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38457 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1BVOqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hv9CpK2NpNODqLn4Z/Hh/ITl4DeWB7G3IkjKVPAXNxnvmkjw3dFZRSCSfw+91gXRQA
         lsgeSEFyNVsYSYF0dBM1x3A8pMHA+H1FdK9T+z5rCE2P1CETreVyPKzhsWnD2YgQSYQN
         aJoPgAEUj5KGrLtOclCn0gDkAFzoBPkA6rufc=
Message-ID: <4D63CC34.6070807@gmail.com>
Date: Tue, 22 Feb 2011 15:46:12 +0100
From: =?UTF-8?B?TWFjaWVqIEtvdGxpxYRza2k=?= <makotlinski@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; pl-PL; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7 ThunderBrowse/3.3.4
MIME-Version: 1.0
To: Karsten Keil <kkeil@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: e1000e EEPROM corruption
References: <20081017135910.GA18206@pingi.kke.suse.de>
In-Reply-To: <20081017135910.GA18206@pingi.kke.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The thread on the list is quite old, but I think I have the same problem 
problem on
Toshiba Tecra M5 laptop with 82573L Gigabit Ethernet Controller runling 
Linux 2.6.38-rc5.
I can see this:
e1000e 0000:02:00.0: (unregistered net_device): The NVM Checksum Is Not 
Valid
when I try to load e1000e module.
Ethernet controller is visible in lspci output.

I had such problem few times earlier but it used to disappear after few 
hours.
Now the network card don't like to work from two days.

When I try to remove NVM check from the driver code the driver says:
(unregistered net_device): Invalid MAC Address: 00:00:00:00:00:00
So I assume that there are zeros in EPROM of my network adapter.
I can not use ethtool to read or write EPROM of my card because there is 
no eth0 device.
I have access to the same laptop, so I can get correct EPROM contents.
Still I don't know how to put this to my card.

Could you tell me how to reprogram my card?

Regards,

Maciek


W dniu 17.10.2008 15:59, Karsten Keil pisze:
> Hi,
>
> so after this ugly bug is finally fixed, here maybe left some victims of
> this bug.
>
> If here is still sombody who need help to recover from this issue,
>
> I can probably help him, I successful recovered all machines on our side,
> even one which do not longer show the NIC via lspci, so the only restiction
> is, that the machine still boots and we have a NVM image of a similar
> machine.
> You should know the PCI ids of the NIC from the time before it crashed and
> the MAC address.
>


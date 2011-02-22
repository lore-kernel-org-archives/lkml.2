Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1BVT7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:59:13 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51681 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1BVT7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:59:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eE0jBpJN1LeZuvhxV8WPVSwOEH2Y5XD1VgGYz5G6z5ObPrfDumI/wyIeT5T/iEB8I/
         suoAq4Ug2yPJn4MXeJuTTpCTTH+XqQnMuVcNkWztZMAAk7+eMIkB2vPDpcBRxw1ThGPw
         FPVtkI3Y0m1j3Xuxnjbe1ye2WDzHoYIzfVoro=
Message-ID: <4D64158B.6010807@gmail.com>
Date: Tue, 22 Feb 2011 20:59:07 +0100
From: =?UTF-8?B?TWFjaWVqIEtvdGxpxYRza2k=?= <makotlinski@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; pl-PL; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7 ThunderBrowse/3.3.4
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Karsten Keil <kkeil@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: e1000e EEPROM corruption
References: <20081017135910.GA18206@pingi.kke.suse.de> <4D63CC34.6070807@gmail.com> <20110222180611.GA724@khazad-dum.debian.net>
In-Reply-To: <20110222180611.GA724@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the way to run my network card without writing anything to EEPROM.

I removed NVM and MAC address checks from e1000e driver source.
The module loads fine. Ethernet adapter have MAC 00:00:00:00:00:00.
Than I change MAC to correct one by ifconfig eth0 hw ether.
Network works fine. I could even read correct data by ethtool -e.
It makes the problem more strange. The correct EEPROM is there but...



W dniu 22.02.2011 19:06, Henrique de Moraes Holschuh pisze:
> On Tue, 22 Feb 2011, Maciej Kotliński wrote:
>> I had such problem few times earlier but it used to disappear after
>> few hours.
> Looks like a hardware issue to me. Cold/broken solders (reflowing the board
> could fix it), for example.
>
>> I have access to the same laptop, so I can get correct EPROM contents.
>> Still I don't know how to put this to my card.
>>
>> Could you tell me how to reprogram my card?
> That would only help if the problem is a "weak programming" of the EEPROM,
> which is something I have never seen before.  Writing to it with flacky
> circuitry is probably going to crap it for good.
>


Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0KZRay (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 26 Nov 2010 12:30:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58312 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KZRax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:30:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kW8VfklgsqchSa1/ZmM4IvA2wqPChRjaEj9iKxuXUknA5g7Iauqn4ghyDjvRvi0Yz8
         X15vxwiQNE8ULQ1OP1JLUGZ0GGUIISnKjitjkLSUzfpaZ54tJg1T7x528xwKEjGXWedU
         Dt/to6nhgnwq+A6LH1FqQNEKR1XsYDd2ZAWQQ=
Message-ID: <4CEFEEC6.20900@gmail.com>
Date: Fri, 26 Nov 2010 18:30:46 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Message
References: <AANLkTinSigE4JPsFByPCkFd-+_oXQwR-V9=AsSH9Warz@mail.gmail.com>	<1290755809.2678.14.camel@edumazet-laptop>	<AANLkTi=8nWFHeJ0Z-WhprNqZMGprMRG5LQ+b3wKoMWWv@mail.gmail.com>	<AANLkTi=bELgtgcWcy59KCvKwWWiuVZBb7e_hTSBHZ4cH@mail.gmail.com>	<20101126073805.GB14282@liondog.tnic> <AANLkTikBgxBsGudfiN-xnN-KRNaanFrPpwOH_EMJ-oic@mail.gmail.com>
In-Reply-To: <AANLkTikBgxBsGudfiN-xnN-KRNaanFrPpwOH_EMJ-oic@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 08:41 AM, Alessandro Tagliapietra wrote:
> 2010/11/26 Borislav Petkov <bp@alien8.de>:
>> adding linux-ide.
> 
> Thank you, i've also attached at this ubuntu bug:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/658521
> the dmesg from ubuntu 10.10 and 11.04 with bios settings as RAID and AHCI.

Can you please just attach them?

-- 
tejun

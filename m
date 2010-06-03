Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab0FCKLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:11:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52927 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab0FCKLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ggZfhE+coxt3Z4F19ti1l+63u+6rDGRaL18JFm0PK7cSO8FavQvpfTOAVPm33ldT9q
         yQmmolRZg+FSIybhTVe4tY1eu82E+sb2IRl8qX4i5DCRzNoMlRHNj5oB4u8Yzb894eQn
         CEP2FuIyr4KVJPaS5qCiOzDQvwEUr/3+BpBRs=
Message-ID: <4C077FD1.1030707@gmail.com>
Date: Thu, 03 Jun 2010 03:11:29 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Robert Hancock <hancockrwd@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
References: <4C05F3BF.6090503@gmail.com>	<AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>	<4C06ECAA.3060708@gmail.com>	<4C06ED18.2010400@gmail.com>	<4C06F1DD.8060004@gmail.com>	<AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>	<4C06F6EA.6090701@gmail.com>	<20100603013758.GA18755@srcf.ucam.org>	<AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>	<4C071048.9040209@gmail.com>	<20100603021851.GA19546@srcf.ucam.org> <20100603105438.7b8f3ee8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100603105438.7b8f3ee8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 02:54 AM, Alan Cox wrote:
> On Thu, 3 Jun 2010 03:18:51 +0100
> Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>
>> On Wed, Jun 02, 2010 at 07:15:36PM -0700, Justin P. Mattock wrote:
>>> as soon as I change:
>>>
>>> int main() {
>>> 	iopl(3);
>>> 	outb(6, 0xcf9);
>>> 	usleep(100);
>>> 	outb(6, 0xcf9);
>>> 	return 0;
>>> }
>>> (the above gave a command prompt
>>> with numerous tries)
>>
>> Ok, so it's not that straghtforward. Sigh. There's various hacky
>> workarounds we could do here, but Windows doesn't seem to do them so I
>> lean towards suspecting that there's something wrong with our keyboard
>> controller reboot mechanism. I'll try doing some more tracing.
>
> At least some PCs you need to issue the reboot outb calls on the boot
> processor so the userspace tests won't be reliable.
>


well.. the userspace is unreliable from over here..
but if were looking at the issue we might as well
look at the whole problem at hand..
i.g. solving the problem with apple, and solving the
problem with the others..(basically getting rid of this
whole dmi entry list all together..(or at-least most of it)..

but might be a bit much..

Justin P. Mattock

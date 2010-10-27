Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab0J0OtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:49:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48125 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab0J0OtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DBEyR8MLPI8qLUOjYGafW59TaydHjAWQ4O7p6TKAANLXYTkrBUT5AFaS1KxWE+vu8R
         yEWlh0YnqsF+hmQB9v1M46ZX76TUiCsZnYxfeM3IhAdUJnONfF3WKaHAZfQuBZuY/yqs
         ugWLGpbY0tqmghH31E+8/pB1zRw1cBFqU+UOM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinz+GLjR8ybzKYTKmB6SaDWWsr1CNdDqpku9pJH@mail.gmail.com>
References: <AANLkTinzFbVbzvYDL23G6T_J0gLkbQ3oYXRLFvXAFdyY@mail.gmail.com>
	<s5hbp6h0yoh.wl%tiwai@suse.de>
	<AANLkTi=eROZrLq36zX1YRCE1TDWxccs9c+AtrRaLHGsB@mail.gmail.com>
	<s5hiq0o5gp2.wl%tiwai@suse.de>
	<AANLkTinVkWexfarMcrT9+zbg-TJ_w27QqUPZKf3hHzdE@mail.gmail.com>
	<s5hwrp43wsf.wl%tiwai@suse.de>
	<AANLkTincmwKyA+rDrHmcFhvT8z+b7kcyT60SW3EMjfzk@mail.gmail.com>
	<s5h7hh3zszl.wl%tiwai@suse.de>
	<AANLkTinz+GLjR8ybzKYTKmB6SaDWWsr1CNdDqpku9pJH@mail.gmail.com>
Date: Wed, 27 Oct 2010 20:19:19 +0530
Message-ID: <AANLkTi=O2e1RCOF8JR1KjrawiNyFEuX_11Vg7bT04f96@mail.gmail.com>
Subject: Re: ALSA sound/pci/hda/hda_intel.c:2624: no codecs found
From: Jaswinder Singh <jaswinderlinux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 27, 2010 at 6:41 PM, Jaswinder Singh
<jaswinderlinux@gmail.com> wrote:
>
> On Wed, Oct 27, 2010 at 6:35 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Wed, 27 Oct 2010 17:53:52 +0530,
>> Jaswinder Singh wrote:
>>>
>>>
>>> Hmm, very strange, but In BIOS sound is enable. How is this possible.
>>
>> No idea.  Any jumpers?
>>
>
> OK, I will check the jumpers.
>

There is no such option to disable audio with jumpers as per link of
Motherboard manual :

http://www.intel.com/support/motherboards/server/wx58bp/sb/CS-030366.htm
http://download.intel.com/support/motherboards/server/wx58bp/sb/e69058001_wx58bp_productguide_001.pdf

Manual says that Audio codec will be RealTek* ALC889 codec (not sure)

lspci -n says : 8086:3a3e

8086:3a3e is supported or not.

> Here is the link of alsa-info.txt :
> http://userweb.kernel.org/~jaswinder/Corei7/alsa-info.txt
>
> If we can run some more tests, please let me know.
>

Thanks,
--
Jaswinder Singh.

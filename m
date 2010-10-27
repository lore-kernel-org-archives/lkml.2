Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab0J0NLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:11:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51875 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab0J0NLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d8j1K84vqy/qc7YyEphqzslNVNJgRCebGt9rL6rMSMBT5FBhzUcyFxTfQrC14KiZP+
         UvCMcioVFq/VZ4SxQD13TafbD6gcXrqGJyw8IcdUMffnyvjNkHSQjdC1BLBC2VJHbX8z
         AvzNk2wpUEthSvX1TiE2ssJgbIWHyruqfBZ9g=
MIME-Version: 1.0
In-Reply-To: <s5h7hh3zszl.wl%tiwai@suse.de>
References: <AANLkTinzFbVbzvYDL23G6T_J0gLkbQ3oYXRLFvXAFdyY@mail.gmail.com>
	<s5hbp6h0yoh.wl%tiwai@suse.de>
	<AANLkTi=eROZrLq36zX1YRCE1TDWxccs9c+AtrRaLHGsB@mail.gmail.com>
	<s5hiq0o5gp2.wl%tiwai@suse.de>
	<AANLkTinVkWexfarMcrT9+zbg-TJ_w27QqUPZKf3hHzdE@mail.gmail.com>
	<s5hwrp43wsf.wl%tiwai@suse.de>
	<AANLkTincmwKyA+rDrHmcFhvT8z+b7kcyT60SW3EMjfzk@mail.gmail.com>
	<s5h7hh3zszl.wl%tiwai@suse.de>
Date: Wed, 27 Oct 2010 18:41:51 +0530
Message-ID: <AANLkTinz+GLjR8ybzKYTKmB6SaDWWsr1CNdDqpku9pJH@mail.gmail.com>
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

On Wed, Oct 27, 2010 at 6:35 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 27 Oct 2010 17:53:52 +0530,
> Jaswinder Singh wrote:
>>
>>
>> Hmm, very strange, but In BIOS sound is enable. How is this possible.
>
> No idea.  Any jumpers?
>

OK, I will check the jumpers.

Here is the link of alsa-info.txt :
http://userweb.kernel.org/~jaswinder/Corei7/alsa-info.txt

If we can run some more tests, please let me know.

Thanks,
--
Jaswinder Singh.

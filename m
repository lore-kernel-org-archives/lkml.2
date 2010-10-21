Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab0JUH5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:57:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61376 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0JUH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sXdsaLHyrePuR6/3JBIKPk5hjPUMszh7KB9IPeThwVMGg0eUKtt8UcExq6cM3KOQvD
         ihkk0KZq9xZ76w7fz2LC5hxtb8YxWXAryq/1khMKv31EvSx9NQC5DfH1V1rQugGMZdcC
         yMtB9G8mVGmZTJFqD3g/t81K64eETmueL/HLY=
Message-ID: <4CBFF25C.2080908@gmail.com>
Date: Thu, 21 Oct 2010 09:57:16 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, clemens@ladisch.de,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com> <s5hlj5sc7do.wl%tiwai@suse.de>
In-Reply-To: <s5hlj5sc7do.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 09:49 AM, Takashi Iwai wrote:
> At Thu, 21 Oct 2010 09:41:08 +0200,
> Jiri Slaby wrote:
>> alsa-info:
>> http://www.alsa-project.org/db/?f=a7a09703bcc8c43386c87a984e513ce35fc91ca4
> 
> I see the Front volume is set to zero.  Try to raise it.

I set all the values to ~ 70 and then tried with pure alsa. It basically
works.

BUT, when I run pulse and it suspends the device (or whatever), all the
levels get down to 0 back again. When I raise it and run mplayer, it
gets to 0 immediately. If I raise it gets to 0 when mplayer finishes and
pulse writes 'protocol-native.c: Connection died.'. It never raises
automatically. And if I raise it during playback, nothing plays at all.

regards,
-- 
js

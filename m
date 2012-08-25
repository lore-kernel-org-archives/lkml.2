Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2HYMDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:03:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53184 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2HYMC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:02:58 -0400
Message-ID: <5038BEEB.6090303@gmail.com>
Date: Sat, 25 Aug 2012 14:02:51 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>
CC: Josh Boyer <jwboyer@redhat.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
References: <20120824190808.GC20043@zod.bos.redhat.com> <5038007E.5060505@gmail.com> <20120825111749.GA17048@wolff.to> <20120825115423.GA14327@wolff.to>
In-Reply-To: <20120825115423.GA14327@wolff.to>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.2012 13:54, Bruno Wolff III wrote:
> On Sat, Aug 25, 2012 at 06:17:49 -0500,
>    Bruno Wolff III <bruno@wolff.to> wrote:
>>
>> I see this behavior on three different computers. Rebooting into an old
>> enough kernel gets things working again. The older kernels also have 
>> older initramfs images. I could rebuild those to see if there is some 
>> issue there instead of the kernels themselves?
> 
> I tested one of the older kernels (where the headset still worked) with a 
> rebuilt initramfs and the headset still worked. So it likely isn't an issue 
> with something in the initramfs images.
> 

Can you revert commit e9ba389c5 ("ALSA: usb-audio: Fix
scheduling-while-atomic bug in PCM capture stream") and see if that
helps? If not, can you summarize again which kernels still work for you
and which don't?


Daniel


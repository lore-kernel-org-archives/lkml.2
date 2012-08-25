Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2HYMOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:14:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47551 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2HYMOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:14:14 -0400
Message-ID: <5038C186.7000107@gmail.com>
Date: Sat, 25 Aug 2012 14:13:58 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>
CC: Josh Boyer <jwboyer@redhat.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
References: <20120824190808.GC20043@zod.bos.redhat.com> <5038007E.5060505@gmail.com> <20120825111749.GA17048@wolff.to> <20120825115423.GA14327@wolff.to> <5038BEEB.6090303@gmail.com> <20120825120740.GA19539@wolff.to>
In-Reply-To: <20120825120740.GA19539@wolff.to>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.2012 14:07, Bruno Wolff III wrote:
> On Sat, Aug 25, 2012 at 14:02:51 +0200,
>    Daniel Mack <zonque@gmail.com> wrote:
>>
>> Can you revert commit e9ba389c5 ("ALSA: usb-audio: Fix
>> scheduling-while-atomic bug in PCM capture stream") and see if that
> 
> I can try that, but it takes a long time to build a new kernel on my 
> old hardware.
> 
>> helps? If not, can you summarize again which kernels still work for you
>> and which don't?
> 
> The latest kernel that works is 3.6.0-0.rc2.git1.2.fc18. The earliest that 
> doesn't work is 3.6.0-0.rc2.git2.1.fc18.
> 

The report you sent doesn't look like it could be caused by e9ba389c5.
It fixes a kernel Ooops. But as it is the only relevant patch in that
area, it would be interesting if reverting it fixes anything.

Btw - thanks a lot for testing -rc kernels, much appreciated!


Daniel


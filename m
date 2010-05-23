Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0EWIgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:36:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57169 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab0EWIgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aZCwG3OMBFaWmx4c5qfQv5udZhfhCbvsk3rrEjRvooXWz4DYvQYigNRrxv8oM/dF+C
         6Ab9iPKDy2m84h3tmWqebjkcX5/IXowET96w+FTAJwxfGBuzj+D5XhM3D0kB7xcTCq/P
         nf0vwMY/5bqO/Te0y83CFtfVfj/mqDHdfSm/I=
MIME-Version: 1.0
In-Reply-To: <20100521140613.GA15070@infradead.org>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
	 <20100521140613.GA15070@infradead.org>
Date: Sun, 23 May 2010 10:36:01 +0200
X-Google-Sender-Auth: flJZCX2er3qvpNRoAwA6u9TPiEU
Message-ID: <AANLkTik_ZNPYFlGpfvoKSipwYbhW9JRuHh7D0IYZUwdm@mail.gmail.com>
Subject: Re: bkl: Pushdowns for sound/oss ?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 16:06, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 21, 2010 at 03:45:04PM +0200, John Kacur wrote:
>> I was looking at doing some of that last remaining ioctl bkl-pushdowns, in
>> particular in:
>> sound/oss/swarm_cs4297a.c
>> sound/oss/msnd_pinnacle.c
>> sound/oss/sh_dac_audio.c
>> sound/oss/vwsnd.c
>> sound/oss/dmasound/dmasound_core.c
>> sound/oss/dmasound/dmasound_core.c
>>
>> when I noticed they were including asm files from mips. I went so far as
>> to compile my own mips tool chain, but I wasn't able to compile the above.
>> Being oss sound, I was wondering if these are still maintained or are
>> marked for removal some time in the future.
>>
>> If there is merely a problem with my toolchain, then that can be fixed,
>> but there is no point in wasting time with these if no-one uses them.
>
> Can we just drop OSS?  It's beend deprecated and mostly dead for years.

There are no ALSA equivalents for the m68k Amiga/Atari/Q40 dmasound drivers yet.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

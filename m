Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1G1SYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:24:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45435 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab1G1SYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <s5hzkjy5l7m.wl%tiwai@suse.de>
References: <1310585610-434-1-git-send-email-geert@linux-m68k.org>
	<20110724122624.324d10dc.rdunlap@xenotime.net>
	<s5hy5zm3j5a.wl%tiwai@suse.de>
	<20110725091003.c3453b8b.rdunlap@xenotime.net>
	<20110727121320.f50b1e6b.rdunlap@xenotime.net>
	<20110728111709.8303f78c9b5f2b3aa3f391b0@canb.auug.org.au>
	<20110728092116.cc318545.rdunlap@xenotime.net>
	<CACqU3MXUt_Kcvu_uHmnS9Wm_hV73HaCgKcggAK350LBsL-EYbg@mail.gmail.com>
	<20110728094418.3bd4e9df.rdunlap@xenotime.net>
	<CACqU3MVkOqGr0WVrCiVEU5QtfC0mcOiruCc9_rm8VL44SRFmiA@mail.gmail.com>
	<s5hzkjy5l7m.wl%tiwai@suse.de>
Date: Thu, 28 Jul 2011 14:24:49 -0400
Message-ID: <CACqU3MUfGwDwWbszG22NJoakmXj1b4So_w2kd7B-DoREz3KE8w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc7 (sound/isa/)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 28, 2011 at 2:11 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 28 Jul 2011 13:06:19 -0400,
> Arnaud Lacombe wrote:
>>
>> Hi,
>>
>> On Thu, Jul 28, 2011 at 12:44 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> > On Thu, 28 Jul 2011 12:36:27 -0400 Arnaud Lacombe wrote:
>> >
>> >> Hi,
>> >>
>> >> On Thu, Jul 28, 2011 at 12:21 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> >> > On Thu, 28 Jul 2011 11:17:09 +1000 Stephen Rothwell wrote:
>> >> >
>> >> >> Hi Randy,
>> >> >>
>> >> >> On Wed, 27 Jul 2011 12:13:20 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>> >> >> >
>> >> >> > On Mon, 25 Jul 2011 09:10:03 -0700 Randy Dunlap wrote:
>> >> >> >
>> >> >> > > On Mon, 25 Jul 2011 09:37:53 +0200 Takashi Iwai wrote:
>> >> >> > >
>> >> >> > > > At Sun, 24 Jul 2011 12:26:24 -0700,
>> >> >> > > > Randy Dunlap wrote:
>> >> >> > > > >
>> >> >> > > > > On Wed, 13 Jul 2011 21:33:30 +0200 Geert Uytterhoeven wrote:
>> >> >> > > > >
>> >> >> > > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declaration of function 'snd_dma_disable':  => 544
>> >> >> > > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declaration of function 'snd_dma_pointer':  => 302
>> >> >> > > > > >   + src/sound/isa/ad1816a/ad1816a_lib.c: error: implicit declaration of function 'snd_dma_program':  => 244
>> >> >> > > > > >   + src/sound/isa/es1688/es1688_lib.c: error: implicit declaration of function 'snd_dma_pointer':  => 509
>> >> >> > > > > >   + src/sound/isa/es1688/es1688_lib.c: error: implicit declaration of function 'snd_dma_program':  => 417
>> >> >> > > > > >   + src/sound/isa/gus/gus_dma.c: error: implicit declaration of function 'snd_dma_disable':  => 177
>> >> >> > > > > >   + src/sound/isa/gus/gus_dma.c: error: implicit declaration of function 'snd_dma_program':  => 79
>> >> >> > > > > >   + src/sound/isa/gus/gus_pcm.c: error: implicit declaration of function 'snd_dma_pointer':  => 619
>> >> >> > > > > >   + src/sound/isa/gus/gus_pcm.c: error: implicit declaration of function 'snd_dma_program':  => 591
>> >> >> > > > > >   + src/sound/isa/sb/sb16_main.c: error: implicit declaration of function 'snd_dma_pointer':  => 456
>> >> >> > > > > >   + src/sound/isa/sb/sb16_main.c: error: implicit declaration of function 'snd_dma_program':  => 276
>> >> >> > > > > >   + src/sound/isa/sb/sb8_main.c: error: implicit declaration of function 'snd_dma_pointer':  => 425
>> >> >> > > > > >   + src/sound/isa/sb/sb8_main.c: error: implicit declaration of function 'snd_dma_program':  => 172
>> >> >> > > > > >   + src/sound/isa/sscape.c: error: implicit declaration of function 'snd_dma_program':  => 481
>> >> >> > > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of function 'snd_dma_disable':  => 1695
>> >> >> > > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of function 'snd_dma_pointer':  => 1160
>> >> >> > > > > >   + src/sound/isa/wss/wss_lib.c: error: implicit declaration of function 'snd_dma_program':  => 1025
>> >> >> > > > >
>> >> >> > > > > All of these source files do #include <sound/core.h>,
>> >> >> > > > > but these missing/implicit functions are conditional:
>> >> >> > > > >
>> >> >> > > > > #ifdef CONFIG_ISA_DMA_API
>> >> >> > > > > #define DMA_MODE_NO_ENABLE    0x0100
>> >> >> > > > >
>> >> >> > > > > void snd_dma_program(unsigned long dma, unsigned long addr, unsigned int size, unsigned short mode);
>> >> >> > > > > void snd_dma_disable(unsigned long dma);
>> >> >> > > > > unsigned int snd_dma_pointer(unsigned long dma, unsigned int size);
>> >> >> > > > > #endif
>> >> >> > > > >
>> >> >> > > > > so should these drivers all depend on ISA_DMA_API ?
>> >> >> > > >
>> >> >> > > > Yes, these are ISA sound cards, so they must have CONFIG_ISA and
>> >> >> > > > CONFIG_ISA_DMA.  Although CONFIG_SND_SB8_DSP, CONFIG_SND_SB16_DSP
>> >> >> > > > and CONFIG_SND_WSS_LIB have no direct dependency, but the drivers
>> >> >> > > > selecting these are all in "if SND_ISA" in sound/isa/Kconfig.
>> >> >> > >
>> >> >> > > Hm, yes, they are.
>> >> >> > >
>> >> >> > > > > or should only pieces of each driver depend on ISA_DMA_API ?
>> >> >> > > >
>> >> >> > > > I wonder which configuration makes it possible.
>> >> >> > > > Did you see a similar problem with randconfig?
>> >> >> > >
>> >> >> > > No.  This parisc allmodconfig file from linux-next builds has
>> >> >> > > CONFIG_SND_ISA=y but it does not have CONFIG_ISA_DMA_API enabled.  Weird.
>> >> >> > >
>> >> >> > > Geert, do you know how this happens?
>> >> >> > >
>> >> >> > > parisc config:  http://kisskb.ellerman.id.au/kisskb/buildresult/4323458/config/
>> >> >> > > from this failed build:  http://kisskb.ellerman.id.au/kisskb/buildresult/4323458/
>> >> >> >
>> >> >> > How is CONFIG_ISA_DMA_API enabled in parisc allmodconfig?
>> >> >> > I don't see how that happens, and it's causing build errors...
>> >> >>
>> >> >> Sorry, but I don't understand the question.  The problam is that
>> >> >> CONFIG_ISA_DMA_API is not enabled, right?  On parisc, it is just (from
>> >> >> arch/parisc/Kconfig)
>> >> >>
>> >> >> config ISA_DMA_API
>> >> >>       bool
>> >> >>
>> >> >> and nothing selects it.  However, I would have expected an allmodconfig
>> >> >> to set it to y.  Clearly I don't understan how allmodconfig works any
>> >> >> more :-(
>> >> >>
>> >> >> Michal, is my understanding correct?  Is this a bug in allmodconfig?
>> >> >
>> >> > When I do:
>> >> > $ make ARCH=parisc O=PAR allmodconfig
>> >> >
>> >> > I don't get CONFIG_ISA_DMA_API enabled, so the question is simply
>> >> > how is the linux-next build system ending up with CONFIG_ISA_DMA_API enabled?
>> >> >
>> >> Where do you see that "linux-next build system ending up with
>> >> CONFIG_ISA_DMA_API enabled" ?
>> >>
>> >> From what I understood of the problem, the issue is that
>> >> CONFIG_ISA_DMA_API does _not_ ends up enabled.
>> >
>> > Thanks for catching me.
>> >
>> > The problem (second try) is that ISA SND drivers are being built (on parisc)
>> > even though ISA_DMA_API is not enabled -- and should not be enabled,
>> > so the ISA SND drivers should not be built.  I think I have it right this time.
>> >
>> > From the parisc .config file listed above:
>> >
>> > CONFIG_SND_ISA=y
>> > CONFIG_SND_ADLIB=m
>> > CONFIG_SND_AD1816A=m
>> > CONFIG_SND_AD1848=m
>> > CONFIG_SND_ALS100=m
>> > CONFIG_SND_AZT1605=m
>> > CONFIG_SND_AZT2316=m
>> > CONFIG_SND_AZT2320=m
>> > CONFIG_SND_CMI8330=m
>> >
>> >
>> > etc.  But none of these should be enabled.  AFAIK.
>> > So how does this happen?
>> >
>> warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct
>> dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API)
>
> Hm, I thought this was fixed by
> commit 4756fc64ecd628efa6f8296711d7dbcefabf25dd
> Author: Ralf Baechle <ralf@linux-mips.org>
> Date:   Fri Jun 24 10:30:09 2011 -0300
>
>    [media] MEDIA: Fix non-ISA_DMA_API link failure of sound code
>
> OK, it landed after 3.0-rc7, so this problem must be fixed now?
% git checkout v3.0-rc7
% make ARCH=parisc allmodconfig
[...]
warning: (RADIO_WL128X) selects TI_ST which has unmet direct
dependencies (MISC_DEVICES && NET && GPIOLIB)
warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct
dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API)
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP
&& FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet
direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML ||
AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)
#
# configuration written to .config
#
% grep -c SND_ISA .config
1

% git checkout v3.0
Previous HEAD position was 620917d... Linux 3.0-rc7
HEAD is now at 02f8c6a... Linux 3.0
% make ARCH=parisc allmodconfig
[...]
warning: (RADIO_WL128X) selects TI_ST which has unmet direct
dependencies (MISC_DEVICES && NET && GPIOLIB)
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP
&& FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet
direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML ||
AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)
#
# configuration written to .config
#
% grep -c SND_ISA .config
0

Look good to me.

 - Arnaud

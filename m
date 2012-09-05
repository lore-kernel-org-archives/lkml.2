Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab2IEMLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:11:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2IEMLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:11:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/17] arm: ux500: add ccu9540 board support
Date: Wed, 5 Sep 2012 12:11:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Loic PALLARDY <loic.pallardy@st.com>,
        Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "LT ST-Ericsson" <st-ericsson@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com> <201209051042.00887.arnd@arndb.de> <504739B8.10604@st.com>
In-Reply-To: <504739B8.10604@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209051211.13021.arnd@arndb.de>
X-Provags-ID: V02:K0:3OiRFrmj8EJW6j+ivb98m58YR7yjSbE03fOR1VV1RWd
 lCKWqFs/NyUYJAu1juQbxrcF5ZB/xteNR/r/CC+2XoWmuL1eIV
 IPMhFTSscVOwtc5X4PYX7GN2FHh/VAmMviEoblrQXqeUHZ4xtk
 ui+BlQPl52SdxHhSoUoFXUOoqMfI1GkV/mAt84eLbR1445a2WW
 gkKCBJ76Nkg7RHkvTxCr6qWwvG9ukwLRSa62Ej1nPlu221RiOO
 FjJ6EGCqk4Pksz8bQAQ79i1C/pZD6vg2oTWecq4U7ijKVsp70e
 ozr7i6Kv1L8bSb+5jYWaUQGFCl7QIJ4KP8LIEg9rbDPPTmM0RN
 +6gvJGGybNSOIKRBHdY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012, Loic PALLARDY wrote:
> 
> On 09/05/2012 12:42 PM, Arnd Bergmann wrote:
> > On Wednesday 05 September 2012, Loic Pallardy wrote:
> >> +MACHINE_START(U9540, "ST-Ericsson 9540 platform")
> >> +       .atag_offset    = 0x100,
> >> +       .map_io         = u8500_map_io,
> >> +       .nr_irqs        = UX500_NR_IRQS,
> >> +       .init_irq       = ux500_init_irq,
> >> +       .timer          =&ux500_timer,
> >> +       .handle_irq     = gic_handle_irq,
> >> +       .init_machine   = u9540_init_machine,
> >> +       .init_late      = ux500_init_late,
> >> +MACHINE_END
> >> +
> >
> > Please don't add another ATAG based board definition to ux500. We're closing in
> > on having full support for DT booting with this platform, so your patch is just
> > making it harder for us to complete this.
> >
> >       Arnd
> Yes I know and agree.
> Please consider this patch as a temporary one waiting for 9540 support 
> from Lee.

Why are you even posting the patches that you know won't make it then?

	Arnd

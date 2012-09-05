Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2IEMl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:41:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60875 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2IEMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <201209051211.13021.arnd@arndb.de>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
	<201209051042.00887.arnd@arndb.de>
	<504739B8.10604@st.com>
	<201209051211.13021.arnd@arndb.de>
Date: Wed, 5 Sep 2012 14:41:27 +0200
Message-ID: <CACRpkdb3KtkxoL6CntaHTu3U0=fCW0NcKVL6i6gKT4JUJ9gZtQ@mail.gmail.com>
Subject: Re: [st-ericsson] [PATCH 02/17] arm: ux500: add ccu9540 board support
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 2:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 05 September 2012, Loic PALLARDY wrote:
>>
>> On 09/05/2012 12:42 PM, Arnd Bergmann wrote:
>> > On Wednesday 05 September 2012, Loic Pallardy wrote:
>> >> +MACHINE_START(U9540, "ST-Ericsson 9540 platform")
>> >> +       .atag_offset    = 0x100,
>> >> +       .map_io         = u8500_map_io,
>> >> +       .nr_irqs        = UX500_NR_IRQS,
>> >> +       .init_irq       = ux500_init_irq,
>> >> +       .timer          =&ux500_timer,
>> >> +       .handle_irq     = gic_handle_irq,
>> >> +       .init_machine   = u9540_init_machine,
>> >> +       .init_late      = ux500_init_late,
>> >> +MACHINE_END
>> >> +
>> >
>> > Please don't add another ATAG based board definition to ux500. We're closing in
>> > on having full support for DT booting with this platform, so your patch is just
>> > making it harder for us to complete this.
>> >
>> >       Arnd
>> Yes I know and agree.
>> Please consider this patch as a temporary one waiting for 9540 support
>> from Lee.
>
> Why are you even posting the patches that you know won't make it then?

My fault! I wanted an outside look at them before we take them
too far.

I should've requested to have the "RFC" prefix attached to them.

Sorry if it annoyed you too much...

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2IELjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:39:02 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:42091 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab2IELjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:39:00 -0400
From: Loic PALLARDY <loic.pallardy@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>
Date: Wed, 5 Sep 2012 13:38:32 +0200
Subject: Re: [PATCH 02/17] arm: ux500: add ccu9540 board support
Thread-Topic: [PATCH 02/17] arm: ux500: add ccu9540 board support
Thread-Index: Ac2LWvrowgaqJBw/TaawLjeNx75wQA==
Message-ID: <504739B8.10604@st.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <1346839153-6465-3-git-send-email-loic.pallardy-ext@stericsson.com>
 <201209051042.00887.arnd@arndb.de>
In-Reply-To: <201209051042.00887.arnd@arndb.de>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/05/2012 12:42 PM, Arnd Bergmann wrote:
> On Wednesday 05 September 2012, Loic Pallardy wrote:
>> +MACHINE_START(U9540, "ST-Ericsson 9540 platform")
>> +       .atag_offset    = 0x100,
>> +       .map_io         = u8500_map_io,
>> +       .nr_irqs        = UX500_NR_IRQS,
>> +       .init_irq       = ux500_init_irq,
>> +       .timer          =&ux500_timer,
>> +       .handle_irq     = gic_handle_irq,
>> +       .init_machine   = u9540_init_machine,
>> +       .init_late      = ux500_init_late,
>> +MACHINE_END
>> +
>
> Please don't add another ATAG based board definition to ux500. We're closing in
> on having full support for DT booting with this platform, so your patch is just
> making it harder for us to complete this.
>
> 	Arnd
Yes I know and agree.
Please consider this patch as a temporary one waiting for 9540 support 
from Lee.

Regards,
Loic
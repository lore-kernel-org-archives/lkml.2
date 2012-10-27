Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2J0PBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:01:18 -0400
Received: from 12.mo3.mail-out.ovh.net ([188.165.41.191]:60869 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442Ab2J0PBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:01:17 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2012 11:01:17 EDT
Date: Sat, 27 Oct 2012 16:48:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        voice <voice.shen@atmel.com>, "Wu, Josh" <Josh.wu@atmel.com>,
        marek.belisko@open-nandra.com, ivan.shugov@gmail.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [GIT PULL] at91: fixes for 3.7-rc3
Message-ID: <20121027144845.GI18964@game.jcrosoft.org>
References: <5088F131.5040600@atmel.com>
 <201210262053.11498.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210262053.11498.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 17640318266844424964
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrudefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrudefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:53 Fri 26 Oct     , Arnd Bergmann wrote:
> On Thursday 25 October 2012, Nicolas Ferre wrote:
> >       ARM: at91: fix external interrupts in non-DT case
> 
> This patch now leads to build errors with at91x40_defconfig,
> which I've fixed up by applying the patch below on top.
> 
> Please yell if this is not the right fix.
> 
> 	Arnd
> 
> commit 3a8852afde01682083028ee427e0678f9bbddd75
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Fri Oct 26 22:49:09 2012 +0200
> 
>     ARM: at91: fix at91x40 build
>     
>     patch 738a0fd7 "ARM: at91: fix external interrupts in non-DT case"
>     fixed a run-time error on some at91 platforms but did not apply
>     the same change to at91x40, which now doesn't build.
>     
>     This changes at91x40 in the same way that the other platforms
>     were changed.
>     
>     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.

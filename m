Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2L2MWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 07:22:51 -0500
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:42795 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752748Ab2L2MWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 07:22:49 -0500
Date: Sat, 29 Dec 2012 13:13:56 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 0/6 v12] gpio: Add block GPIO
Message-ID: <20121229121356.GB7360@game.jcrosoft.org>
References: <1356281376-25853-1-git-send-email-stigge@antcom.de>
 <20121229102017.GA7360@game.jcrosoft.org>
 <50DEDB99.5080701@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50DEDB99.5080701@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16048014322872593245
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpegrnhhttghomhdruggvnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpegrnhhttghomhdruggvnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:01 Sat 29 Dec     , Roland Stigge wrote:
> Hi,
> 
> On 29/12/12 11:20, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 17:49 Sun 23 Dec     , Roland Stigge wrote:
> >> This set of patches adds:
> >>
> >> * Block GPIO API to gpiolib
> >> * Sysfs support for GPIO API, to provide userland access
> >> * Device interface for userland access (alternative to sysfs)
> >> * Devicetree support to instantiate GPIO blocks via DT
> >> * Example implementations in several gpio drivers since they need
> >>   special accessor functions for block wise GPIO access (only for some
> >>   selected drivers since the feature is optional and not suitable for
> >>   all GPIO hardware)
> >> * Fix for race condition in gpiolib on device creation
> >>
> >> Signed-off-by: Roland Stigge <stigge@antcom.de>
> >> Tested by: Wolfgang Grandegger <wg@grandegger.com>
> >> --
> >>
> >> Testing branch available at: git://git.antcom.de/linux-2.6.git blockgpio
> >>
> >> Changes since v11:
> >> * Removed support for at91, since this one is currently in the migration
> >>   process to pinctrl implementation
> > already done for 3.8
> > 
> > in Linus tree
> 
> Good, thanks for the note! So we include support for block GPIO in
> pinctrl-at91.c now.
> 
> I guess the redundant code in arch/arm/mach-at91/gpio.c will be removed?
no we keep for non DT platform

Best Regards,
J.

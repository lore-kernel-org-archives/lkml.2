Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2JKJ3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:29:18 -0400
Received: from 5.mo4.mail-out.ovh.net ([188.165.44.50]:37352 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754212Ab2JKJ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:29:17 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2012 05:29:16 EDT
Date: Thu, 11 Oct 2012 10:50:02 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 4/6] ARM: ux500: Add UART support to the u9540 Device
 Tree
Message-ID: <20121011085002.GV12801@game.jcrosoft.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-5-git-send-email-lee.jones@linaro.org>
 <20121010190325.GT12801@game.jcrosoft.org>
 <20121011072927.GR9707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011072927.GR9707@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9852187135470513151
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:29 Thu 11 Oct     , Lee Jones wrote:
> On Wed, 10 Oct 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > On 16:18 Wed 10 Oct     , Lee Jones wrote:
> > > Add the 3 UART nodes required to enable serial ports on the u9540.
> > > 
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  arch/arm/boot/dts/u9540.dts |   13 ++++++++++++-
> > dts? it's dtsi
> 
> No it's not.
so the name of the file is wrong s u9540 is a SoC name

Best Regards,
J.

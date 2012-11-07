Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2KGP3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:29:36 -0500
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:42863 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2KGP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:29:35 -0500
Date: Wed, 7 Nov 2012 16:27:29 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Royer <nicolas@eukrea.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, eric@eukrea.com
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 1/5] ARM: AT91SAM9G45: fix crypto peripherals irq issue
 due to sparse irq support.
Message-ID: <20121107152729.GE4576@game.jcrosoft.org>
References: <1352219463-30360-1-git-send-email-nicolas@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352219463-30360-1-git-send-email-nicolas@eukrea.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9105434023217703700
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:31 Tue 06 Nov     , Nicolas Royer wrote:
> Spare irq support introduced by commit "8fe82a5 ARM: at91: sparse irq support"
> involves to add the NR_IRQS_LEGACY offset to irq number.
> 
> Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Eric Bénard <eric@eukrea.com>
> Tested-by: Eric Bénard <eric@eukrea.com>
> Cc: stable@vger.kernel.org # 3.6

ok will see if we can have it for 3.7

Best Regards,
J.

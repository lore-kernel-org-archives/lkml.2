Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842Ab2I2UEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:04:34 -0400
Received: from 2.mo5.mail-out.ovh.net ([178.33.109.111]:44830 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705Ab2I2UEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:04:33 -0400
Date: Sat, 29 Sep 2012 21:53:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 01/12] mtd: atmel nand: build regression
Message-ID: <20120929195321.GB17667@game.jcrosoft.org>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
 <1348868177-21205-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348868177-21205-2-git-send-email-arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5927581534810712836
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:36 Fri 28 Sep     , Arnd Bergmann wrote:
> The atmel_nand driver was broken by b654a9a46fc2 "mtd: atmel nand: fix
> gpio missing request". This is a rather helpless attempt to fix this,
> probably messing up the error handling even further but getting the
> build to work again, so please treat it as a bug report rather than
> a fix to be applied.
> 
> Without this patch, building any at91 configuration results in:
> 
> drivers/mtd/nand/atmel_nand.c: In function 'atmel_nand_probe':
> drivers/mtd/nand/atmel_nand.c:1451:4: error: label 'err_ecc_ioremap' used but not defined

for the record the error come from the merge of the pmecc and the commit you
mention
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
I already have seach path in my quere from Josh

Best Regards,
J.


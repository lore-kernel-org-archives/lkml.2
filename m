Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2KUQBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:01:19 -0500
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:34825 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KUQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:01:18 -0500
Date: Wed, 21 Nov 2012 16:53:12 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH v5] linux,stdout-path helper
Message-ID: <20121121155312.GX4398@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 1.7.10.4
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 17968236614556625751
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrudejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehoiihlrggsshdrohhrghenucfjughrpeffhfhsvffukfggtgguofgfsehttdfttderredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrudejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehoiihlrggsshdrohhrghenucfjughrpeffhfhsvffukfggtgguofgfsehttdfttderredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following adds a helper for matching the linux,stdout-path property
in the chosen node and makes use of it in the i.MX serial and Atmel serial driver.

changes since v4:

 - add option support and check stdout-path too

changes since v3:

- move code from separate files to drivers/of/base.c and include/linux/of.h

changes since v2:

- move helper to OF core and make it independent of serial devices

changes since v1:

- move it out of the i.MX serial driver and make it generic for serial
  devices.

_______________________________________________
devicetree-discuss mailing list
devicetree-discuss@lists.ozlabs.org
https://lists.ozlabs.org/listinfo/devicetree-discuss

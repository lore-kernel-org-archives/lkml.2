Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2BTJZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:25:43 -0500
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:54340 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752101Ab2BTJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:25:42 -0500
X-Greylist: delayed 27589 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Feb 2012 04:25:42 EST
Date: Mon, 20 Feb 2012 10:18:09 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ryan Mallon <rmallon@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 04/18] ARM: at91: make ST (System Timer) soc independent
Message-ID: <20120220091809.GB28066@game.jcrosoft.org>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
 <957702b1ff83afcc0a8e842f53f05ff3f40b78b3.1329500622.git.nicolas.ferre@atmel.com>
 <4F419246.6080405@gmail.com>
 <20120220013825.GD29599@game.jcrosoft.org>
 <4F41A76D.1070409@gmail.com>
 <20120220030234.GE29599@game.jcrosoft.org>
 <20120220073301.GA22562@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220073301.GA22562@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1265792970464013235
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:33 Mon 20 Feb     , Russell King - ARM Linux wrote:
> On Mon, Feb 20, 2012 at 04:02:34AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 12:52 Mon 20 Feb     , Ryan Mallon wrote:
> > > That isn't an excuse to leave incorrect code there. It is a simple fix.
> > no (void) in c means you don't care of the return so basically it's right
> 
> Let's be clear: it's legal, but redundant and unnecessary.
So as I said it's no the focus of this patch

I don't want to do it at the same time

Best Regards,
J.

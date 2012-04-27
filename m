Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2D0Gs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:48:59 -0400
Received: from 7.mo4.mail-out.ovh.net ([178.33.253.54]:39103 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756519Ab2D0Gs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:48:56 -0400
X-Greylist: delayed 53319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 02:48:56 EDT
Date: Fri, 27 Apr 2012 08:28:16 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng <b29396@freescale.com>, b20223@freescale.com,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kernel@pengutronix.de, cjb@laptop.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120427062816.GQ9142@game.jcrosoft.org>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
 <20120426151536.GO9142@game.jcrosoft.org>
 <20120427054842.GJ2234@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427054842.GJ2234@S2101-09.ap.freescale.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4702039487785642966
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:48 Fri 27 Apr     , Shawn Guo wrote:
> On Thu, Apr 26, 2012 at 05:15:36PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > We have on Imx mxc at91 and other SoC controler hich you configure per pin
> > 
> > which means one pin have multiple function and the same function is on
> > multiple pins
> > 
> > so the groups are just a list of possible pins
> > 
> > Instead of re-inventing bindings we do need to come with a common binding whre
> > it's possible
> > 
> > So instead I proppose (send in the v2) to use common way to describe the group
> > 
> Let's see how many nodes we will have in device tree.  For imx6q
> example, there are 332 pins and each pin has up to 8 function selects.
> We will end up with having 332 x 8 = 2656 sub nodes under node
> "functions".  Device tree simply cannot afford such a bloating.
device tree can offord it

except you are going to have hundereds of duplicated pinctrl configuration
as different board will have different mux which is impossbile to maintain
either

and I do not expect we add all the configuration possible but just the common
one

Best Regards,
J.

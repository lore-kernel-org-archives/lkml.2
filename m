Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2BVOGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:06:16 -0500
Received: from 16.mo5.mail-out.ovh.net ([87.98.174.144]:49662 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585Ab2BVOGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:06:14 -0500
X-Greylist: delayed 3304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Feb 2012 09:06:14 EST
Date: Wed, 22 Feb 2012 14:57:58 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rmallon@gmail.com
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 07/19] ARM: at91/pm_slowclock: function slow_clock()
 accepts parameters
Message-ID: <20120222135758.GC9407@game.jcrosoft.org>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
 <5b8fbdf669825987a82b3b89b2e7f02239cad816.1329903206.git.nicolas.ferre@atmel.com>
 <20120222095250.GV22562@n2100.arm.linux.org.uk>
 <20120222125814.GA9407@game.jcrosoft.org>
 <20120222131816.GB22562@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222131816.GB22562@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 17744182532723747763
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:18 Wed 22 Feb     , Russell King - ARM Linux wrote:
> On Wed, Feb 22, 2012 at 01:58:14PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > Btw I'm looking on a way to switch the assembly funciton to C but I didn,t find a
> > good way to calculate the function size except by touching at the linker
> > script. Which I don;t want to do.
> 
> Forget doing it in C.  C is too complicated, because either you have to
> keep its relocations and fix them up, or you have to compile and link it
> to run at a specific location and then copy it to that location.  You
> also have literal pools to think about.
> 
> Assembly is much better controlled and you can write it so that you don't
> end up with any of that stuff.  You have absolute control over the code
> and associated data.
ok

Best Regards,
J.

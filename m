Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2H2UQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 16:16:40 -0400
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:42790 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2H2UQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 16:16:38 -0400
X-Greylist: delayed 14999 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2012 16:16:38 EDT
Date: Wed, 29 Aug 2012 17:28:20 +0200
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: mxc_nand.c on mach-imx/imx53
Message-ID: <20120829172820.43bbe68e@eb-e6520>
In-Reply-To: <503E3331.8050203@antcom.de>
References: <5035F84E.3000901@antcom.de>
	<20120829074122.GV26594@pengutronix.de>
	<503E3331.8050203@antcom.de>
Organization: =?ISO-8859-1?B?RXVrculh?= Electromatique
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 3730950818151509341
X-Ovh-Remote: 82.240.38.71 (pac33-2-82-240-38-71.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrfeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucffohhmrghinhepphgvnhhguhhtrhhonhhigidruggvnecujfgurhepfffhvffukfgjfhhoofggtgfgsehtqhertdertddu
X-Spam-Check: DONE|U 0.500268/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrfeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucffohhmrghinhepphgvnhhguhhtrhhonhhigidruggvnecujfgurhepfffhvffukfgjfhhoofggtgfgsehtqhertdertddu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

Le Wed, 29 Aug 2012 17:20:17 +0200,
Roland Stigge <stigge@antcom.de> a écrit :
> Using  ".ecclayout_4k = &nandv2_hw_eccoob_4k" also doesn't work. So is
> there any hint how I can proceed from here? Any plans or hint regarding
> the "XXX"?
> 
you may need something like this patch from barebox :
http://git.pengutronix.de/?p=barebox.git;a=commit;h=632c45795065e6a7471ab82be38e808eb6204341

I may have time to adapt this next week but if you have time before feel
free to do it ;-)

Eric

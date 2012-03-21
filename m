Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668Ab2CUKDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:03:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030290Ab2CUKDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:03:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Date: Wed, 21 Mar 2012 08:59:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Turquette, Mike" <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <201203170905.33191.arnd@arndb.de> <alpine.DEB.2.00.1203201731550.22974@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1203201731550.22974@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203210859.11899.arnd@arndb.de>
X-Provags-ID: V02:K0:A4QCZz2MiSB5URPXqiL2YFwjmmyIglLkuYUqDPwm6uW
 3u/dhwD9K50pFpWSiJoTNreHYmm23lQZ/pt8Tb2zgKE0n1D9yb
 pbhliOpir2IFVXjqm8+OQht+S2ob3pmx2QXVMWVCXEI4qbCPfW
 mfCnCSH81f1fP88IsaiOAk8PO3oyJYujB23ZTfYmEP28PuMSzw
 8a/Y86PmFXEfvQgz22I7GdoHQ4JjS6uOE/Dx9/8oYTYS+yYfS6
 R2es0DBv41/+UEnyB3DYK9PxNAKTPmYckaCYV+FIFlV0kp1LQb
 g1ND+1j0Ovzi+lQlXpGYqXSgsZPYCNfwsSZHDFYB+jQFz4Tyif
 Di/jPBB7qq707ZTpArpI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2012, Paul Walmsley wrote:
> Hello Arnd,
> 
> On Sat, 17 Mar 2012, Arnd Bergmann wrote:
> 
> > I think it's rather pointless, because the option is not going to
> > be user selectable but will get selected by the platform unless I'm
> > mistaken. The platform maintainers that care already know the state
> > of the framework.
> 
> This is where we have differing views, I think.  Clearly, Sascha, 
> Saravana, Rob, and I have at least slightly different opinions on the 
> durability of the existing API and code.  So it seems reasonable to assume 
> that others who have not followed the development of the common clock code 
> might mistake the implementation or API as being stable and well-defined.
> 
> It sounds like the primary objection is to the use of CONFIG_EXPERIMENTAL.  
> So here is a patch to simply note the status of this code in its Kconfig 
> text.

Yes, looks good to me. If there are no objections, I'll apply this one.

Thanks,

	Arnd


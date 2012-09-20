Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2ITKDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:03:17 -0400
Received: from londo.lunn.ch ([80.238.139.98]:53905 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab2ITKDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:03:16 -0400
Date: Thu, 20 Sep 2012 12:02:54 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/11] pinctrl: mvebu: pinctrl driver
Message-ID: <20120920100254.GE21928@lunn.ch>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <CACRpkda+Kav6RGstSQ9+BCgVV+pR6ca_HmoueODYubX_xYM8Jw@mail.gmail.com>
 <505AD103.8050004@gmail.com>
 <20120920110424.3cb4daff@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920110424.3cb4daff@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

> Hum, which patches are stalling the integration into the Marvell tree?

l2 cache, I think.

The trees Jason built for pull requests in the direction of arm-soc
had the l2 cache patch as the very first in the series. Now that these
patches have run into some trouble, its blocking all the patches that
followed.

Jason is re-building his trees, throwing out l2 cache for the
moment. That should allow Olof/Arnd to pull these trees into arm-soc,
and then Jason will work on integrating the remaining patches not
already in his trees.

	Andrew

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2JKEVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:21:19 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:10220 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2JKEVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:21:16 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 20:48:21 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: RE: [RFC PATCH 04/06] input/rmi4: Config files and makefiles
Thread-Topic: [RFC PATCH 04/06] input/rmi4: Config files and makefiles
Thread-Index: AQHNo3hY/7wG9OxLzUuixYQVVVPjfpexKbWAgAJfQ2o=
Date: Thu, 11 Oct 2012 04:23:14 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22C3C@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-5-git-send-email-cheiny@synaptics.com>,<CACRpkdagphG+z4d-6BREkgOy4Qza=-uKw49Mpn-wPDJKCpudTA@mail.gmail.com>
In-Reply-To: <CACRpkdagphG+z4d-6BREkgOy4Qza=-uKw49Mpn-wPDJKCpudTA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.10.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> On Sat, Oct 6, 2012 at 6:10 AM, Christopher Heiny <cheiny@synaptics.com>
> wrote:
> 
> (...)
> 
> > diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
> 
> (...)
> 
> > +config RMI4_DEBUG
> > +       bool "RMI4 Debugging"
> > +       depends on RMI4_BUS
> 
> select DEBUG_FS
> 
> This has been illustrated many times in the review. You definatley
> have code depending on debugfs when this is selected.

Agreed.
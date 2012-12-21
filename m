Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2LUKvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:51:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42818 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2LUKvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:51:09 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Loic PALLARDY <loic.pallardy@st.com>, Tony Lindgren <tony@atomide.com>
CC: Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Gutierrez, Juan" <jgutierrez@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>, Tejun Heo <tj@kernel.org>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        "Anna, Suman" <s-anna@ti.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/9] mailbox: OMAP: introduce mailbox framework
Thread-Topic: [PATCH 1/9] mailbox: OMAP: introduce mailbox framework
Thread-Index: AQHN3SJyVkNHHwjuo0Kw3VTcOGqtQJgea4WAgAQvkQCAAHt0MA==
Date: Fri, 21 Dec 2012 10:49:51 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC9CF77@DBDE01.ent.ti.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <1355836212-17956-2-git-send-email-loic.pallardy-ext@stericsson.com>
 <20121218165909.GF4989@atomide.com> <50D423C2.3090009@st.com>
In-Reply-To: <50D423C2.3090009@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.119]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 14:24:26, Loic PALLARDY wrote:
> 
> 
> On 12/18/2012 05:59 PM, Tony Lindgren wrote:
> > * Loic Pallardy<loic.pallardy-ext@stericsson.com>  [121218 05:15]:
> >>
> >> Signed-off-by: Omar Ramirez Luna<omar.luna@linaro.org>
> >
> > AFAIK the first two patches should have:
> > From: Omar Ramirez Luna<omar.luna@linaro.org>
> Yes right, my mistake.
> I'll fix that on next version.
> /Loic

I have a few patches which are dependent on this patch series.
Could you please keep me in cc for the future versions.

Thanks,
Vaibhav

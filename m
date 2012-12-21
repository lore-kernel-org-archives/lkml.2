Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2LUKaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:30:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58302 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab2LUKaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:30:03 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Gutierrez, Juan" <jgutierrez@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>, Tejun Heo <tj@kernel.org>,
        "Anna, Suman" <s-anna@ti.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 5/9] mailbox: change protection mechanisms
Thread-Topic: [PATCH 5/9] mailbox: change protection mechanisms
Thread-Index: AQHN3SJ+dafG9FWHhkKLZDpYU1kNsJgjEP1g
Date: Fri, 21 Dec 2012 10:28:48 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC9CE80@DBDE01.ent.ti.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <1355836212-17956-6-git-send-email-loic.pallardy-ext@stericsson.com>
In-Reply-To: <1355836212-17956-6-git-send-email-loic.pallardy-ext@stericsson.com>
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

On Tue, Dec 18, 2012 at 18:40:08, Loic Pallardy wrote:
> TX: replace spin by mutex
> RX: replace spin_lock_irq by spin_lock_irqsave
> 

Can you please add a short note on why this is being done?

Regards,
Vaibhav 


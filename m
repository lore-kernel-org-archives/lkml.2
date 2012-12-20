Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2LTS3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:29:06 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:18317 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875Ab2LTS3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:29:01 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18GLcYWB/83fc6OHKkRhN74
Date: Thu, 20 Dec 2012 10:28:36 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Loic Pallardy <loic.pallardy-ext@stericsson.com>, arm@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Suman Anna <s-anna@ti.com>, Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: Re: [PATCH 0/9] drivers: mailbox: framework creation
Message-ID: <20121220182835.GB21056@atomide.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <CACRpkdaqO7AAeYeR8SZt4Tbv1grrMq85TNYMc-FSbUSrnZBm=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaqO7AAeYeR8SZt4Tbv1grrMq85TNYMc-FSbUSrnZBm=Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [121220 10:19]:
> On Tue, Dec 18, 2012 at 2:10 PM, Loic Pallardy
> <loic.pallardy-ext@stericsson.com> wrote:
> 
> > OMAP and ST-Ericsson platforms are both using mailbox to communicate
> > with some coprocessors.
> > Based on OMAP existing mailbox framework, this series proposes a
> > generic framework, living under drivers/mailbox.
> 
> I like this patch series so you have my Acked-by.
> 
> Since it's a new subsystem and affects a few ARM architectures can
> we merge this into the ARM SoC tree once we have consensus,
> so we get some rotation in linux-next that way?

Yes good idea.
 
> Olof/Arnd?

I suggest we set up an immutable branch against
v3.8-rc1 when it's out with only these patches in it.
Then we can all merge it in as needed. Maybe Arnd or
Olof can set up the branch?

FYI, looks like I need to merge in this branch too to
avoid build errors with remoteproc enabled once I flip
on the multiplatform support for omap2+.

Regards,

Tony

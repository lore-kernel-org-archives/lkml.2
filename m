Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2LTSRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:17:10 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:62862 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2LTSQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:16:56 -0500
MIME-Version: 1.0
In-Reply-To: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
Date: Thu, 20 Dec 2012 19:16:54 +0100
Message-ID: <CACRpkdaqO7AAeYeR8SZt4Tbv1grrMq85TNYMc-FSbUSrnZBm=Q@mail.gmail.com>
Subject: Re: [PATCH 0/9] drivers: mailbox: framework creation
From: Linus Walleij <linus.walleij@linaro.org>
To: Loic Pallardy <loic.pallardy-ext@stericsson.com>, arm@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 2:10 PM, Loic Pallardy
<loic.pallardy-ext@stericsson.com> wrote:

> OMAP and ST-Ericsson platforms are both using mailbox to communicate
> with some coprocessors.
> Based on OMAP existing mailbox framework, this series proposes a
> generic framework, living under drivers/mailbox.

I like this patch series so you have my Acked-by.

Since it's a new subsystem and affects a few ARM architectures can
we merge this into the ARM SoC tree once we have consensus,
so we get some rotation in linux-next that way?

Olof/Arnd?

Yours,
Linus Walleij

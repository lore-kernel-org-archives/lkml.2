Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2LQSiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:38:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46702 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2LQSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:38:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121217113611.GA31470@balto.lan>
References: <1354615845-2758-1-git-send-email-fabio.baltieri@linaro.org>
	<20121217113611.GA31470@balto.lan>
Date: Mon, 17 Dec 2012 19:38:50 +0100
Message-ID: <CACRpkdYRJvFEUvB++fKgVWEXZrTQ7aob0MPMwW4TBs_VRNuzsA@mail.gmail.com>
Subject: Re: [PATCH 0/2] clocksource: nomadik-mtu: support timer-based delay
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>,
        John Stultz <johnstul@us.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 12:36 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Tue, Dec 04, 2012 at 11:10:43AM +0100, Fabio Baltieri wrote:
>> this implements timer-based delay support for nomadik and ux500
>> platforms, using the MTU as time source, and marks the u8500 cpufreq
>> driver as CPUFREQ_CONST_LOOPS accordingly.
>>
>> The patches are based on Arnd's arm-soc/ux500/mtu-clk branch, as that
>> contains latest MTU driver developments, including a driver move/rename,
>> but I can rebase if necessary.
>
> The patches applies cleanly on current mainline now, as all dependencies
> has already been merged, can this be considered for for merging too?

If no clocksource maintainer steps up in a week then notify me and
I'll simply stick these into the ux500 tree.

Yours,
Linus Walleij

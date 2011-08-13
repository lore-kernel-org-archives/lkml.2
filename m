Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1HMTC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:02:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61885 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1HMTC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:02:57 -0400
Date: Sat, 13 Aug 2011 14:02:46 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mattia Dongili <malattia@debian.org>
Subject: Re: [BUG?] Moving drivers to drivers/cpufreq/ causes all to be loaded
Message-ID: <20110813190246.GA10412@elie.gateway.2wire.net>
References: <20110414094447.GA1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104211629300.24613@xanadu.home>
 <201104261605.26791.arnd@arndb.de>
 <201104261904.45923.rjw@sisk.pl>
 <20110426181508.GB1908@redhat.com>
 <20110813154638.GA1494@elie.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813154638.GA1494@elie.gateway.2wire.net>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder wrote:

>  (1) This is still incredibly fragile.  What *should* cpufrequtils
>      be doing to get the modules it needs?
>
>  (2) Using the 3.0 or later kernel with old userspace gives bad
>      results (e.g., 30% increase in power consumption for one
>      reporter).  That's a regression.

The "30% increase" part was an unrelated bug (i915.i915_enable_rc6=1
brings power consumption back to normal), for those who were
wondering. :)

Old userspace automatically loading the wrong cpufreq drivers still
does not seem great to me, though I don't have any great ideas about
how to prevent that (a separate drivers/cpufreq-drivers/ directory
does not sound too appealing).  I guess I'd be most interested in how
to fix (1) first.

Thanks,
Jonathan

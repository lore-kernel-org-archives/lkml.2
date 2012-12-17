Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2LQWDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:03:11 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57636 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2LQWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:03:09 -0500
Date: Mon, 17 Dec 2012 23:03:04 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <johnstul@us.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] cpufreq: db8500: set CPUFREQ_CONST_LOOPS
Message-ID: <20121217220304.GB16231@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>,
	John Stultz <johnstul@us.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
References: <1354615845-2758-1-git-send-email-fabio.baltieri@linaro.org>
 <1354615845-2758-3-git-send-email-fabio.baltieri@linaro.org>
 <50CF634F.1040708@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CF634F.1040708@codeaurora.org>
X-Operating-System: Linux balto 3.7.0-08462-gbc94807 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 10:24:15AM -0800, Stephen Boyd wrote:
> On 12/04/12 02:10, Fabio Baltieri wrote:
> >  static struct cpufreq_driver db8500_cpufreq_driver = {
> > -	.flags  = CPUFREQ_STICKY,
> > +	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
> 
> Wouldn't you want to fold this into the previous patch so bisection is
> not broken? Otherwise you have a place where lpj is all screwed up when
> cpufreq mucks with it.

You are basically right... but that's not going to be as screwed up as
it's now, so I'd say that it's not worth the rebase unless the
maintainer says so. :-)

Thanks!
Fabio

-- 
Fabio Baltieri

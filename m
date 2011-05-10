Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1EJF7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:59:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab1EJF7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:59:39 -0400
Date: Tue, 10 May 2011 01:59:26 -0400
From: Dave Jones <davej@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 10/10] mach-ux500: update and move cpufreq driver
Message-ID: <20110510055926.GA2747@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
 <201105061522.33179.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105061522.33179.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 03:22:33PM +0200, Arnd Bergmann wrote:
 > On Friday 06 May 2011, Linus Walleij wrote:
 > > 
 > > From: Linus Walleij <linus.walleij@linaro.org>
 > > 
 > > This updates the ux500 cpufreq driver to the new interface from the
 > > updated DB8500 PRCMU driver and moves it to drivers/cpufreq as
 > > discussed with Dave Jones.
 > > 
 > > The Makefile change in drivers/cpufreq will collide with Daves commit
 > > moving cpufreq drivers into drivers/cpufreq/*, this needs to be fixed up
 > > in next or the merge window since this driver depend deeply on other
 > > changes in this patchset and GPIO consolidation.
 > > 
 > > Cc: Arnd Bergmann <arnd@arndb.de>
 > > Cc: Dave Jones <davej@redhat.com>
 > > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
 > 
 > Looks good for all I can tell, but please split this into two patches,
 > one for the conversion to the new interface and one for the actual
 > move. That would make it possible to review the changes you did.

Haven't had chance to really read much patches the last few days
(travelling until the 16th).  Due to the patch collisions we'll keep
seeing on kconfig/Makefiles, should these go via the cpufreq tree,
or do people want to still push them through their respective arch trees ?

When I'm back, I'm happy to take them if that's the decision.

	Dave


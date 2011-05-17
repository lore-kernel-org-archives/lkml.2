Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1EQVMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:12:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab1EQVMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:12:34 -0400
Date: Tue, 17 May 2011 17:12:23 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 10/10] mach-ux500: update and move cpufreq driver
Message-ID: <20110517211223.GA1909@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
 <201105061522.33179.arnd@arndb.de>
 <20110510055926.GA2747@redhat.com>
 <BANLkTimh2Xaz73v-2c0GmcS9wD4+JFWzrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimh2Xaz73v-2c0GmcS9wD4+JFWzrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 11:02:14AM +0200, Linus Walleij wrote:
 > 2011/5/10 Dave Jones <davej@redhat.com>:
 > 
 > > Haven't had chance to really read much patches the last few days
 > > (travelling until the 16th).  Due to the patch collisions we'll keep
 > > seeing on kconfig/Makefiles, should these go via the cpufreq tree,
 > > or do people want to still push them through their respective arch trees ?
 > 
 > I pushed a patch series yesterday that basically deactivates the
 > cpufreq driver in the mach-ux500, moves it over to drivers/cpufreq,
 > updates it, then reactivates it in the new place with a patch to
 > the Makefile.

Just got back from travelling, so I'm buried under mail backlog right now.
The only one that jumped out was the one I was cc'd on
([PATCH 10/10] mach-ux500: update and move cpufreq driver).

 > Of these changes only the last patch will collide with your tree,
 > so I pushed all of them except that one to linux-next.
 > 
 > The last patch I plan to submit to Torvalds directly after both
 > trees have gone into the merge window.
 > 
 > Can you please look into this and ACK the patches if they
 > seem OK?

The patch that moves the driver over looked ok to me, so feel free
to add my acked-by to it.

>From the look of things, the Kconfig is staying under arch/arm for now ?

thanks,

	Dave


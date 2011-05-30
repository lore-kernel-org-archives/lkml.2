Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab1E3O12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:27:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59306 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985Ab1E3O10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:27:26 -0400
X-Sasl-enc: Idk2DNvlRSWLQouxjRFDoKbyx6jCE7ibyBtoLuyZaZcc 1306765645
Date: Mon, 30 May 2011 22:02:31 +0800
From: Greg KH <greg@kroah.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Message-ID: <20110530140231.GA11831@kroah.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <201105231730.06564.arnd@arndb.de>
 <7E10264BABCB4C1788DCD9715461BDE8@subhasishg>
 <201105241440.34854.arnd@arndb.de>
 <20110524134338.GA13491@kroah.com>
 <45A0E7B350CB4DF685D18EFE6EB1CB76@subhasishg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45A0E7B350CB4DF685D18EFE6EB1CB76@subhasishg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 06:55:12PM +0530, Subhasish Ghosh wrote:
> Greg,
> 
> >There really are only 3 rules:
> >- proper license
> >- self-contained in a drivers/staging/DRIVER_NAME/ directory
> >- must properly build
> >
> >>Mainly, this includes having a patch that adds a single
> >>directory with all the driver files under drivers/staging.
> >>The driver must be able to compile without errors and you need
> >>a TODO file listing the remaining issues that prevent you
> >>from having a non-staging driver.
> >
> >Ah, forgot the TODO on the list of rules, I'll have to add that next
> >time.
> >
> How do I handle the headers. I have two header files in the
> include/linux/mfd.

Why would they be in there for a single driver?

> Should I submit them as a separate patch into mfd.
> 
> These headers are also used by pruss uart implementation.

Then put them in the staging directory for your driver, why would
anything outside of your driver need a .h file?

thanks,

greg k-h

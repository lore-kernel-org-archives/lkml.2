Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0IRFiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 01:38:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab0IRFiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 01:38:04 -0400
Date: Fri, 17 Sep 2010 22:38:49 -0700
From: Greg KH <gregkh@suse.de>
To: Nishanth Menon <nm@ti.com>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Lnus Walleij <linus.walleij@stericsson.com>,
        Phil <ext-phil.2.carmody@nokia.com>,
        Kevin <khilman@deeprootsystems.com>
Subject: Re: [PATCH v2] power: introduce library for device-specific OPPs
Message-ID: <20100918053849.GA19709@suse.de>
References: <1284787459-25643-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284787459-25643-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 12:24:19AM -0500, Nishanth Menon wrote:
> This is hence introduced under lib allowing all architectures to
> selectively enable the feature based on their capabilities.

<snip>

>  Documentation/power/00-INDEX |    2 +
>  Documentation/power/opp.txt  |  326 ++++++++++++++++++++++++++
>  drivers/base/power/Makefile  |    1 +
>  drivers/base/power/opp.c     |  527 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/opp.h          |  126 ++++++++++
>  kernel/power/Kconfig         |   14 ++
>  6 files changed, 996 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/power/opp.txt
>  create mode 100644 drivers/base/power/opp.c
>  create mode 100644 include/linux/opp.h

That doesn't look like the files are under lib/

Did you forget to move them, or do you need to update the changelog
message?

thanks,

greg k-h

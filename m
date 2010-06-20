Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0FTKK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 06:10:26 -0400
Received: from elvis.franken.de ([193.175.24.41]:49673 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430Ab0FTKKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 06:10:23 -0400
X-Greylist: delayed 2613 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jun 2010 06:10:23 EDT
Date: Sun, 20 Jun 2010 11:26:10 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
       linux-fbdev@vger.kernel.org, linux-mmc@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org,
       lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH v2 00/26] Add support for the Ingenic JZ4740
	System-on-a-Chip
Message-ID: <20100620092610.GA4950@alpha.franken.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276924111-11158-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 07:08:05AM +0200, Lars-Peter Clausen wrote:
> This patch series adds support for the Ingenic JZ4740 System-on-a-Chip.

great stuff. I have a JZ4730 based netbook, for which I started magling
the provided sources quite some time ago, but I didn't reach the
point of submitting patches... there are a lot of common stuff between
JZ4730 and JZ4740 so IMHO it would be a good thing not to nail
everthing to JZ4740 namewise. It might also a good idea to select
something like arch/mips/jzrisc as base directory, put the
factored out code there and add JZ4730/JZ4740 in either seperate
files or directories.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]

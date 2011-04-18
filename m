Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1DRGC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 02:02:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1DRGCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 02:02:13 -0400
Date: Sun, 17 Apr 2011 23:02:18 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/14] Remove sysdev suspend/resume and shutdown operations
Message-ID: <20110418060218.GB22168@suse.de>
References: <201103280125.11750.rjw@sisk.pl>
 <201104172301.54115.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104172301.54115.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 11:01:53PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> The following series of patches fixes bugs related to the introduction
> of struct syscore_ops later in this cycle, replaces sysdev suspend/resume
> operations in all of the architectures still using them with struct
> syscore_ops-based PM callbacks and finally removes the suspend/resume
> and shutdown operations from struct sysdev_class and struct sysdev_driver.
> 
> Patches [1/14] and [2/14] are important bug fixes targeted at 2.6.39.
> The remaining patches are regareded as 2.6.40 material, but I'd like to
> put them into linux-next shortly, if there are no objections, to catch
> problems that they may introduce before they hit the mainline.  Again,
> if there are no objections I'd like to merge these patches through the
> suspend-2.6 tree.

No objection from me at all, thanks for doing this they look great.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab2AFItK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 03:49:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2AFItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:49:08 -0500
Date: Fri, 6 Jan 2012 08:48:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Govindraj.R" <govindraj.raja@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20120106084841.GJ11810@n2100.arm.linux.org.uk>
References: <20120106120317.500c45afe95ae20b4b6648a0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106120317.500c45afe95ae20b4b6648a0@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 12:03:17PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap2/pm34xx.c between commit e6ab10af962d ("ARM: OMAP:
> convert idle handlers from pm_idle to arm_pm_idle") from the arm tree and
> commit 2fd149645eb4 ("") from the arm-soc tree.

Err, there's an empty description of a commit in the arm-soc tree?

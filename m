Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2AWRFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:05:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33937 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2AWRFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:05:03 -0500
Date: Mon, 23 Jan 2012 17:04:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RESEND PATCH] arm:davinci: prepare to move aemif driver to
	drivers/mfd
Message-ID: <20120123170436.GZ1068@n2100.arm.linux.org.uk>
References: <1327331552-9913-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327331552-9913-1-git-send-email-prakash.pm@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 08:42:32PM +0530, Manjunathappa, Prakash wrote:
> Adding: MFD maintainer and mailing list.
> 
>  arch/arm/mach-davinci/aemif.c              |    2 +-
>  arch/arm/mach-davinci/board-da830-evm.c    |    2 +-
>  arch/arm/mach-davinci/board-da850-evm.c    |    2 +-
>  arch/arm/mach-davinci/include/mach/aemif.h |   36 ----------------------------
>  drivers/mtd/nand/davinci_nand.c            |    2 +-
>  include/linux/mfd/davinci_aemif.h          |   36 ++++++++++++++++++++++++++++
>  6 files changed, 40 insertions(+), 40 deletions(-)
>  delete mode 100644 arch/arm/mach-davinci/include/mach/aemif.h
>  create mode 100644 include/linux/mfd/davinci_aemif.h

As Linus has requested on many occasions, and it's a damned good
idea, use -M when generating diffstat - and its also a *really* good
idea to use -M if you're submitting patches which rename files for
review as well.

Obviously arch/arm/mach-davinci/include/mach/aemif.h was moved to
include/linux/mfd/davinci_aemif.h, but were there any changes to its
contents?  Without -M, there only way of knowing is to compare each
file line by line.  With -M, it'll tell us that it was renamed and
produce a diff between the old and new location.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2GHWWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:22:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:48908 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab2GHWWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174799798"
Date: Mon, 9 Jul 2012 00:34:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/7] mfd: Wolfson Arizona and WM5102 support
Message-ID: <20120708223423.GD15345@sortiz-mobl>
References: <20120623125446.GX4037@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623125446.GX4037@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Jun 23, 2012 at 01:54:47PM +0100, Mark Brown wrote:
> This patch series adds the MFD core driver for the WM5102 and other
> Wolfson Arizona class devices.  
> 
> The series has a dependency on a new regmap feature, support for wake
> IRQs.  Assuming the code is OK I don't know how you want to handle this
> - I've provided a pull request below which in turn pulls in a signed tag
> from the regmap tree so you can pull into the MFD tree providing you
> there's no rebases.  Alternatively I could carry the code in the regmap
> tree, though that might get a bit silly as it'll dwarf the actual
> changes in there.
> 
> The following changes since commit 485802a6c524e62b5924849dd727ddbb1497cc71:
> 
>   Linux 3.5-rc3 (2012-06-16 17:25:17 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd/wm5102
Pulled, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1LREsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 23:48:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59247 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1LREsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 23:48:37 -0500
Date: Sat, 17 Dec 2011 20:48:31 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Gary King <gking@nvidia.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v7 00/14] Add support for tegra30 and cardhu
Message-ID: <20111218044831.GB4336@quad.lixom.net>
References: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:03:12PM +0200, Peter De Schrijver wrote:
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.

Thanks, applied to for-3.3/dt (first patch) and for-3.3/soc (the rest).
I didn't want to split up too much between the branches and make
cross-dependencies since that defeats most of the idea behind topic branches,
so I left it at that.

I rebased for-3.3/soc (which only had one patch on it before) to be on top of
rmk's devel-stable and for-3.3/dt, and will tell Arnd about those dependencies
when sending up the branches -- other SoCs have similar dependencies already so
it's not a problem.

I had to do some minor touchups, including redoing the move of board-dt.c due
to other changes to the file. Please check final contents of the branch and let
me know if there's a problem.

Also, the defconfig needs to be updated to enable t30 support as well as move
over to the new config option for t20. I'll post a patch in a few minutes.

Please let me know how the branch looks as soon as practical, since the
clock is ticking on getting the branches into arm-soc in the next few
days for the upcoming merge window.


-Olof

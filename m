Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1KGXJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:09:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36442 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1KGXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:09:16 -0500
Date: Mon, 7 Nov 2011 23:08:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 0/8] Add support for tegra30 and cardhu
Message-ID: <20111107230853.GW12913@n2100.arm.linux.org.uk>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:20:07PM +0200, Peter De Schrijver wrote:
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.
> 
> Pathset is on top of Will Deacon's ARM reset work.

Note that there's another solution for the arch_reset() stuff floating
around (mine) which goes a tad further than Will's, specifically avoiding
the problems of having multiple function pointers for this stuff.

My version also cleans up the use of the identity mappings for non-soft
restarts, which is going to be needed to fix soft-restarts on ARMv6+v7
properly (as well as migrating all the soft-restart support to something
a little saner.)

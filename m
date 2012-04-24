Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2DXI10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:27:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11001 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DXI1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:27:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Apr 2012 01:27:06 -0700
Date: Tue, 24 Apr 2012 11:26:39 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: tegra: Initialize pll_p_out1
Message-ID: <20120424082639.GW514@tbergstrom-lnx.Nvidia.com>
References: <1335169910-29403-1-git-send-email-pdeschrijver@nvidia.com>
 <4F9583DA.2090107@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F9583DA.2090107@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 06:31:22PM +0200, Stephen Warren wrote:
> On 04/23/2012 02:31 AM, Peter De Schrijver wrote:
> > pll_a uses pll_p_out1 as its parent. Therefore this clock needs to be
> > initialized to make sure pll_a has a known input clock. Failure to do so
> > will cause the system to crash early in the bootup.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Thanks, applied.
> 
> > --
> > 
> > Changes in v2:
> 
> 
> BTW, that "--" needs to be "---" if you don't intend the changelog to
> end up in git when I apply the patch.

Ok :) I should have just removed this as v1 has never been posted here...

Cheers,

Peter.

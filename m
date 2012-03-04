Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2CDSv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:51:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43444 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2CDSv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:51:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.225.164 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 4 Mar 2012 10:51:55 -0800
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Nicolas Pitre (nico@fluxnic.net)" <nico@fluxnic.net>,
        "Russell King - ARM Linux (linux@arm.linux.org.uk)" 
	<linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: Enable CPUIdle on Tegra20
Message-ID: <20120304185155.GA363@quad.lixom.net>
References: <1330014056-26125-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC9AB@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC9AB@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 09:25:34AM -0800, Stephen Warren wrote:
> Peter De Schrijver wrote at Thursday, February 23, 2012 9:21 AM:
> > As the LP3 code also works for Tegra20, we can enable cpuidle for Tegra20.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> Note that the commit which added this line appears to have been made in
> Nicolas's idle branch, which was merged into Russell's for-armsoc branch.
> This presumably impacts the path through which this fix should get merged.
> 
> (hence leaving the patch below for Nicolas/Russell to see)

Thanks, applied.


-Olof

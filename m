Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2ADM2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:28:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13704 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab2ADM2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:28:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Jan 2012 04:28:25 -0800
Date: Wed, 4 Jan 2012 14:28:17 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] Tegra30 clockframework
Message-ID: <20120104122817.GI32619@tbergstrom-lnx.Nvidia.com>
References: <1325517486-22458-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F1220@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17761F1220@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 12:03:30AM +0100, Stephen Warren wrote:
> Peter De Schrijver wrote at Monday, January 02, 2012 8:18 AM:
> > This patchset introduces the tegra30 clockframework. Clocks which require
> > voltage scaling are not included in this version. The implementation doesn't
> > use the generic clock code yet. It's the intention to move to it, once the
> > semantics are fully clarified.
> 
> I'm not particularly familiar with Tegra's clocks, but nothing really
> stood out as wrong with this patch on a quick look-through. It'd be great
> if someone like Colin could look this over.
> 
> A couple thoughts below. You've probably thought about some of these
> already, but I just wanted to make sure:-)
> 
> * Are we following the common clock stuff so we can move over once it's
> ready?
> 

I think we can use the same approach then OMAP4 to convert this to the common
clock stuff.

> * Are Tegra20 and Tegra30 so different we can't re-use any of the code
> in tegra2_clocks.c for Tegra30?
> 

Apart from some small functions (such as clk_measure_input_freq()), it's not
easy to share code between both.

> * The device names in the peripheral clock table might benefit from a
> review to make sure they match tegra2_clocks.c for the drivers we've
> actually upstreamed at least.

Good point. I should check that...

Cheers,

Peter.

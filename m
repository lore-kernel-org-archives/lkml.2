Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab1KDQar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:30:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59028 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab1KDQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:30:46 -0400
Date: Fri, 4 Nov 2011 16:30:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 2/8] arm/tegra: prepare early init for multiple
	tegra variants
Message-ID: <20111104163017.GA12913@n2100.arm.linux.org.uk>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com> <1320242948-21061-3-git-send-email-pdeschrijver@nvidia.com> <CAMbhsRSTcR8qgYESmM6OxkXeVeg6vS49woCe_OX6CY4pAj2g_A@mail.gmail.com> <20111103092116.GO13358@tbergstrom-lnx.Nvidia.com> <20111103100235.GK12913@n2100.arm.linux.org.uk> <CAOesGMh7LqUtBkB5Dffr-bJSkC__V+55yLsp7KAYs-6oRAGMhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMh7LqUtBkB5Dffr-bJSkC__V+55yLsp7KAYs-6oRAGMhA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 08:09:42AM -0700, Olof Johansson wrote:
> Sounds reasonable to me. Want a patch to put in your arch_reset
> cleanup branch, I presume? I'll post something later today.

I would, but I've just changed the method slightly.

It was becoming silly adding functions to every platform to initialize
arm_pm_restart() in some way (preferably as early as possible) so I've
scrapped that idea.

I've just replaced it with something a little better, which is to put
a pointer directly in the machine_desc stuff, and have generic code
setup the pointer if this is set.

I'll post some new patches sometime in the next few days.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2ATNCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:02:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57124 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab2ATNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:02:05 -0500
Date: Fri, 20 Jan 2012 13:02:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] mfd: tps65910: Add wakeup support
Message-ID: <20120120130201.GF18297@opensource.wolfsonmicro.com>
References: <1327057770-6688-1-git-send-email-ldewangan@nvidia.com>
 <20120120125152.GE18297@opensource.wolfsonmicro.com>
 <4F196568.1080503@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F196568.1080503@nvidia.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 06:30:24PM +0530, Laxman Dewangan wrote:

> I did not get how the wakeup enabled in power management infrastructure?
> My understanding is that we need to call the two apis
> device_wakeup_init() and
> enable_irq_wake() for enabling the wakeup functionality.
> Is there any other API which does the same and I need to call from
> the core driver?

No, that's it - when you call those userspace will get control via sysfs
for turning on and off the wakeup support.

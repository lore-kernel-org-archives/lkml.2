Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2G0SU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:20:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45772 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2G0SU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:20:27 -0400
Date: Fri, 27 Jul 2012 11:20:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120727182023.GC23564@kroah.com>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 09:05:48PM +0900, Alexandre Courbot wrote:
> +++ b/include/linux/power_seq.h
> @@ -0,0 +1,139 @@
> +/*
> + * power_seq.h
> + *
> + * Simple interpreter for defining power sequences as platform data or device
> + * tree properties. Initially designed for use with backlight drivers.
> + *
> + * Power sequences are designed to replace the callbacks typically used in
> + * board-specific files that implement board-specific power sequences of devices
> + * such as backlights. A power sequence is an array of resources (which can a
> + * regulator, a GPIO, a PWM, ...) with an action to perform on it (enable or
> + * disable) and optional pre and post step delays. By having them interpreted
> + * instead of arbitrarily executed, it is possible to describe these in the
> + * device tree and thus remove board-specific code from the kernel.
> + *
> + * Author: Alexandre Courbot <acourbot@nvidia.com>
> + *
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

As I always say:
	Unless you want to track the office movements of the FSF for the
	next 40 years, and keep this file up to date, drop that last
	paragraph, it's pointless.


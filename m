Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab2BWMqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:46:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36802 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2BWMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:46:38 -0500
Date: Thu, 23 Feb 2012 12:46:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] gpio/omap: fix trigger type to unsigned
Message-ID: <20120223124625.GH22675@n2100.arm.linux.org.uk>
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com> <1329999031-6914-6-git-send-email-tarun.kanti@ti.com> <4F463374.3080502@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F463374.3080502@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 06:09:16PM +0530, Shubhrajyoti wrote:
> On Thursday 23 February 2012 05:40 PM, Tarun Kanti DebBarma wrote:
> > -static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
> > +static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
> > +							unsigned trigger)
> you meant unsigned int ? could it be made u32.

In C, unsigned is the same as unsigned int.

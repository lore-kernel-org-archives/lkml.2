Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1FUKHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:07:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58662 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932111Ab1FUKHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:07:02 -0400
Date: Tue, 21 Jun 2011 11:07:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20110621100700.GB22177@opensource.wolfsonmicro.com>
References: <20110621130331.368aaf74.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621130331.368aaf74.sfr@canb.auug.org.au>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:03:31PM +1000, Stephen Rothwell wrote:

> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:

> drivers/mfd/wm831x-core.c: In function 'wm831x_device_init':
> drivers/mfd/wm831x-core.c:1507:12: error: 'WM831X_XTAL_ENA' undeclared (first use in this function)

> Caused by commit e1af6eaa2160 ("mfd: Only register wm831x RTC device if
> the 32.768kHz crystal is enabled").

I sent a patch adding this at the time the patch was originally added -
I'll resend it shortly.

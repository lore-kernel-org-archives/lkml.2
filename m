Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab2GHRCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 13:02:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49192 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2GHRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 13:02:42 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 8 Jul 2012 10:02:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 4/4] hwmon / exynos4_tmu: Use struct dev_pm_ops for power
 management
Message-ID: <20120708170244.GA16423@roeck-us.net>
References: <201207072302.16491.rjw@sisk.pl>
 <201207072306.09305.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207072306.09305.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 11:06:08PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the Exynos4 TMU driver define its PM callbacks through
> a struct dev_pm_ops object rather than by using legacy PM hooks
> in struct platform_driver.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Please fix:

WARNING: line over 80 characters
#313: FILE: drivers/hwmon/exynos4_tmu.c:496:
+static SIMPLE_DEV_PM_OPS(exynos4_tmu_pm, exynos4_tmu_suspend, exynos4_tmu_resume);

Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab1GASLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:11:20 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:51261 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab1GASLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:11:18 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 3/10 v6] PM / Domains: Support for generic I/O PM domains (v7)
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201106252324.13454.rjw@sisk.pl>
	<201106252326.23837.rjw@sisk.pl>
Date: Fri, 01 Jul 2011 11:11:13 -0700
In-Reply-To: <201106252326.23837.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 25 Jun 2011 23:26:23 +0200")
Message-ID: <87tyb5yipq.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introduce common headers, helper functions and callbacks allowing
> platforms to use simple generic power domains for runtime power
> management.
>
> Introduce struct generic_pm_domain to be used for representing
> power domains that each contain a number of devices and may be
> parent domains or subdomains with respect to other power domains.
> Among other things, this structure includes callbacks to be
> provided by platforms for performing specific tasks related to
> power management (i.e. ->stop_device() may disable a device's
> clocks, while ->start_device() may enable them, ->power_off() is
> supposed to remove power from the entire power domain
> and ->power_on() is supposed to restore it).
>
> Introduce functions that can be used as power domain runtime PM
> callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> as well as helper functions for the initialization of a power
> domain represented by a struct generic_power_domain object,
> adding a device to or removing a device from it and adding or
> removing subdomains.
>
> Introduce configuration option CONFIG_PM_GENERIC_DOMAINS to be
> selected by the platforms that want to use the new code.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Reviewed-by: Kevin Hilman <khilman@ti.com>

While I still don't think this is generic enough for some more
complicated SoCs, it most certainly a huge step in the right direction,
and I think we can address the other complexities with additional
patches as needed.

Thanks Rafael for all your hard work on this and putting up with my
nagging. ;)

Kevin

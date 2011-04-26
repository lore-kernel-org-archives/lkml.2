Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1DZM33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:29:29 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:11035 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1DZM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:29:26 -0400
Subject: Re: [PATCH 11/14] PM / AVR32: Use struct syscore_ops instead of
 sysdevs for PM
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <201104172313.09712.rjw@sisk.pl>
References: <201103280125.11750.rjw@sisk.pl>
	 <201104172301.54115.rjw@sisk.pl>  <201104172313.09712.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Tue, 26 Apr 2011 14:22:12 +0200
Message-ID: <1303820532.3125.12.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2011 12:26:49.0711 (UTC) FILETIME=[376147F0:01CC040D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 23:13 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Convert some AVR32 architecture's code to using struct syscore_ops
> objects for power management instead of sysdev classes and sysdevs.
> 
> This simplifies the code and reduces the kernel's memory footprint.
> It also is necessary for removing sysdevs from the kernel entirely in
> the future.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

Thanks, nice work. Tested and run on hardware.

<snipp>

-- 
Hans-Christian Egtvedt


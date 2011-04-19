Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1DSII2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:08:28 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:50927 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab1DSIIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:08:25 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Greg KH'" <gregkh@suse.de>, "'Kay Sievers'" <kay.sievers@suse.de>,
        "'Linux PM mailing list'" <linux-pm@lists.linux-foundation.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, "'Kevin Hilman'" <khilman@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Mike Frysinger'" <vapier@gentoo.org>,
        "'Ralf Baechle'" <ralf@linux-mips.org>,
        "'Hans-Christian Egtvedt'" <hans-christian.egtvedt@atmel.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Jeremy Fitzhardinge'" <jeremy.fitzhardinge@citrix.com>
References: <201103280125.11750.rjw@sisk.pl> <201104172301.54115.rjw@sisk.pl> <201104172313.45854.rjw@sisk.pl>
In-Reply-To: <201104172313.45854.rjw@sisk.pl>
Subject: RE: [PATCH 12/14] PM / UNICORE32: Use struct syscore_ops instead of sysdevs for PM
Date: Tue, 19 Apr 2011 16:02:55 +0800
Message-ID: <006201cbfe68$3ad01380$b0703a80$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGigRf2YbaBbwN3nae5nt2hV/RFAQE9f7yfAR5lag2UpO7MUA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Monday, April 18, 2011 5:14 AM
> To: LKML
> Cc: Greg KH; Kay Sievers; Linux PM mailing list; Russell King; linux-omap@vger.kernel.org; Kevin Hilman; linux-arm-
> kernel@lists.infradead.org; Ben Dooks; Mike Frysinger; Ralf Baechle; Hans-Christian Egtvedt; Guan Xuetao; Benjamin Herrenschmidt;
> linuxppc-dev@lists.ozlabs.org; Jiri Kosina; Konrad Rzeszutek Wilk; Jeremy Fitzhardinge
> Subject: [PATCH 12/14] PM / UNICORE32: Use struct syscore_ops instead of sysdevs for PM
> 
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make some UNICORE32 architecture's code use struct syscore_ops
> objects for power management instead of sysdev classes and sysdevs.
> 
> This simplifies the code and reduces the kernel's memory footprint.
> It also is necessary for removing sysdevs from the kernel entirely in
> the future.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>


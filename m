Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1BJCLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:11:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:25518 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1BJCLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:11:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,448,1291622400"; 
   d="scan'208";a="656232586"
Subject: Re: [Bug #27812] 2.6.38-rc2: acpi backlight control missing
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Thomas Meyer <thomas@m3y3r.de>
In-Reply-To: <ibChAs1xEQI.A.e_C.qHeSNB@chimera>
References: <QUnbpYCwS-F.A.vaC.VHeSNB@chimera>
	 <ibChAs1xEQI.A.e_C.qHeSNB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 10:08:14 +0800
Message-ID: <1297303694.14594.8.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 07:31 +0800, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27812
> Subject		: 2.6.38-rc2: acpi backlight control missing
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2011-01-22 10:49 (12 days old)
> First-Bad-Commit: http://git.kernel.org/linus/677bd810eedce61edf15452491781ff046b92edc
> Message-ID	: <1295693349.2120.3.camel@localhost.localdomain>
> References	: http://marc.info/?l=linux-kernel&m=129569353414755&w=2
> 
this has been verified to be a duplicate of bug
https://bugzilla.kernel.org/show_bug.cgi?id=27702, and the patch at
https://patchwork.kernel.org/patch/499221/ is a proper fix.

thanks,
rui



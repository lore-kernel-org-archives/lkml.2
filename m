Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab0GHX5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:57:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37844 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0GHX5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:57:35 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Len Brown" <lenb@kernel.org>, "Tom Gundersen" <teg@jklm.no>,
       "Venkatesh Pallipadi" <venki@google.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.9ME.ROmNMB@chimera>
Subject: [Bug #16145] Unable to boot unless "notsc" or "clocksource=hpet", or acpi_pad disabling the TSC
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16145
Subject		: Unable to boot unless "notsc" or "clocksource=hpet", or acpi_pad disabling the TSC
Submitter	: Tom Gundersen <teg@jklm.no>
Date		: 2010-06-07 13:11 (32 days old)
Handled-By	: Venkatesh Pallipadi <venki@google.com>
		  Len Brown <lenb@kernel.org>



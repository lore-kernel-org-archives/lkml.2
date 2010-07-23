Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab0GWMUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:20:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52044 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760059Ab0GWMU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:20:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Ambroz Bizjak" <ambrop7@gmail.com>,
        "Thomas Renninger" <trenn@suse.de>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
In-Reply-To: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PRbv8sgxY6G.A.YUF.7UYSMB@chimera>
Subject: [Bug #16357] acpi-cpufreq fails to load (No such device) if CONFIG_SMP=n
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 14:15:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16357
Subject		: acpi-cpufreq fails to load (No such device) if CONFIG_SMP=n
Submitter	: Ambroz Bizjak <ambrop7@gmail.com>
Date		: 2010-07-09 09:40 (15 days old)
Handled-By	: Thomas Renninger <trenn@suse.de>



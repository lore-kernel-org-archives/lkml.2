Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1GJLFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:05:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab1GJLFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:05:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Borislav Petkov" <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
In-Reply-To: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XNkIyhV6dgF.A.oLH.jCYGOB@chimera>
Subject: [Bug #38152] acpi_power_off lockdep splat
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:38:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38152
Subject		: acpi_power_off lockdep splat
Submitter	: Borislav Petkov <bp@alien8.de>
Date		: 2011-06-19 13:30 (22 days old)
Message-ID	: <20110619133049.GA18168@liondog.tnic>
References	: http://marc.info/?l=linux-kernel&m=130849028317365&w=2
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: https://patchwork.kernel.org/patch/950852/



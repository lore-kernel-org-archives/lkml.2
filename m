Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1FZVuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:50:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59405 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab1FZVrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:47:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Borislav Petkov" <bp@alien8.de>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
In-Reply-To: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XWjMN7gBoXK.A.45C.VZ6BOB@chimera>
Subject: [Bug #38152] acpi_power_off lockdep splat
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jun 2011 23:23:46 +0200 (CEST)
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
Date		: 2011-06-19 13:30 (8 days old)
Message-ID	: <20110619133049.GA18168@liondog.tnic>
References	: http://marc.info/?l=linux-kernel&m=130849028317365&w=2



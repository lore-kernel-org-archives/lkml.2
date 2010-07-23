Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab0GWMXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:23:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580Ab0GWMT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:19:29 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Petr Pisar" <petr.pisar@atlas.cz>,
        "Tim Gardner" <tim.gardner@canonical.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
In-Reply-To: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PRbv8sgxY6G.A.kQG.0VYSMB@chimera>
Subject: [Bug #16111] hostap_pci: infinite registered netdevice wifi0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 14:15:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16111
Subject		: hostap_pci: infinite registered netdevice wifi0
Submitter	: Petr Pisar <petr.pisar@atlas.cz>
Date		: 2010-06-02 20:55 (52 days old)
Handled-By	: Tim Gardner <tim.gardner@canonical.com>
		   Petr Pisar <petr.pisar@atlas.cz>
Patch		: https://patchwork.kernel.org/patch/105008/
		  https://bugzilla.kernel.org/attachment.cgi?id=27109



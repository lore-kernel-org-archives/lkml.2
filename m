Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab0JQU7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:59:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54776 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953Ab0JQU7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:59:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
        "Brian Bloniarz" <brian.bloniarz@gmail.com>,
        "Yinghai Lu" <yinghai@kernel.org>
References: <1SnkuNVk0vO.A.E9E.Qx1uMB@chimera>
In-Reply-To: <1SnkuNVk0vO.A.E9E.Qx1uMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <u4vap2zcaSM.A.u0G.k11uMB@chimera>
Subject: [Bug #16228] BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Oct 2010 22:55:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16228
Subject		: BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
Submitter	: Brian Bloniarz <brian.bloniarz@gmail.com>
Date		: 2010-06-16 17:57 (124 days old)
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: https://patchwork.kernel.org/patch/189182/
		  https://patchwork.kernel.org/patch/189232/
		  https://patchwork.kernel.org/patch/189242/
		  https://patchwork.kernel.org/patch/189252/



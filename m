Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0JCVz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 17:55:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39473 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab0JCVw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 17:52:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Vladislav Bolkhovitin" <vst@vlnb.net>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
In-Reply-To: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N9RAiGGLCfN.A.LSD.4UPqMB@chimera>
Subject: [Bug #16549] 2.6.35: suspicious rcu_dereference_check() usage
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  3 Oct 2010 23:53:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16549
Subject		: 2.6.35: suspicious rcu_dereference_check() usage
Submitter	: Vladislav Bolkhovitin <vst@vlnb.net>
Date		: 2010-08-04 10:56 (61 days old)
Message-ID	: <4C594740.1090608@vlnb.net>
References	: http://marc.info/?l=linux-kernel&m=128091938215177&w=2



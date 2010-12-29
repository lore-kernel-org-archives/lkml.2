Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0L2XbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:31:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0L2XbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:31:15 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Giacomo" <delleceste@gmail.com>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
In-Reply-To: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LbeBv-BNQpL.A.EiH.2E8GNB@chimera>
Subject: [Bug #24752] Random crashes easily reproducible with make -j5 - intel i915 - kernel 2.6.36 on intel/nvidia hybrid graphics machine
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Dec 2010 00:21:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24752
Subject		: Random crashes easily reproducible with make -j5 - intel i915 - kernel 2.6.36 on intel/nvidia hybrid graphics machine
Submitter	: Giacomo <delleceste@gmail.com>
Date		: 2010-12-10 8:57 (20 days old)
Message-ID	: <AANLkTimkQM94u9iz7FVVjehB0mwDwfkNwKhF2F2tYq-r@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129197146619176&w=2



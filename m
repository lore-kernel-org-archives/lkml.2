Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0LSM5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:57:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab0LSM5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:57:13 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Giacomo" <delleceste@gmail.com>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
In-Reply-To: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xqq2Z3iR9HJ.A.hEG.70fDNB@chimera>
Subject: [Bug #24752] Random crashes easily reproducible with make -j5 - intel i915 - kernel 2.6.36 on intel/nvidia hybrid graphics machine
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:50:28 +0100 (CET)
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
Date		: 2010-12-10 8:57 (10 days old)
Message-ID	: <AANLkTimkQM94u9iz7FVVjehB0mwDwfkNwKhF2F2tYq-r@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129197146619176&w=2



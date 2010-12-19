Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0LSMz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:55:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab0LSMzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:55:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
In-Reply-To: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xqq2Z3iR9HJ.A._rH.s2fDNB@chimera>
Subject: [Bug #19372] 2.6.36-rc6: WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:235 radeon_fence_wait+0x35a/0x3c0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:50:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19372
Subject		: 2.6.36-rc6: WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:235 radeon_fence_wait+0x35a/0x3c0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2010-09-29 21:29 (82 days old)
Message-ID	: <20100929212923.GA5578@core2.telecom.by>
References	: http://marc.info/?l=linux-kernel&m=128579579400315&w=2



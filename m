Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0HAOwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 10:52:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab0HAOuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 10:50:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
References: <JKn8_uSlpqD.A.HLG.1LYVMB@chimera>
In-Reply-To: <JKn8_uSlpqD.A.HLG.1LYVMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <FMobw2FohV.A.Y4G.7MYVMB@chimera>
Subject: [Bug #16139] wait_even_interruptible_timeout(), signal, spin_lock() = system hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  1 Aug 2010 16:44:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16139
Subject		: wait_even_interruptible_timeout(), signal, spin_lock() = system hang
Submitter	: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date		: 2010-05-28 16:44 (66 days old)
Message-ID	: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127506510328758&w=2



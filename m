Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab0FTWsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:48:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab0FTWqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:46:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.UH.RapHMB@chimera>
Subject: [Bug #16139] wait_even_interruptible_timeout(), signal, spin_lock() = system hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:34:30 +0200 (CEST)
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
Date		: 2010-05-28 16:44 (24 days old)
Message-ID	: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127506510328758&w=2



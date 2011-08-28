Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1H1TsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:48:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43553 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab1H1ToD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:44:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Andrei Warkentin" <andreiw@motorola.com>,
        "Chris Ball" <cjb@laptop.org>,
        "Peter Vollmer" <vollmerpeter@googlemail.com>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
In-Reply-To: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gUVi6eNP8RE.A.uJH.tfpWOB@chimera>
Subject: [Bug #38922] Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition writing and io errors on insert
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 28 Aug 2011 21:01:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38922
Subject		: Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition writing and io errors on insert
Submitter	: Peter Vollmer <vollmerpeter@googlemail.com>
Date		: 2011-07-07 17:33 (53 days old)
First-Bad-Commit: http://git.kernel.org/linus/a3c7778f8153b9e4eceea6738973280b9e63c618



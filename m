Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab1D3UYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:24:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38998 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758341Ab1D3UWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:22:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Delan Azabani" <delan@azabani.com>
References: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera>
In-Reply-To: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <9nxEC7x0HFO.A.G2F.wxGvNB@chimera>
Subject: [Bug #32112] Writes to USB flash drives are extremely slow in 2.6.38
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Apr 2011 22:17:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32112
Subject		: Writes to USB flash drives are extremely slow in 2.6.38
Submitter	: Delan Azabani <delan@azabani.com>
Date		: 2011-03-29 08:10 (33 days old)



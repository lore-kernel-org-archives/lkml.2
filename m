Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1BLXJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:09:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39534 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab1BLXJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:09:33 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Tao Ma" <tm@tao.ma>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
In-Reply-To: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <8H3lez1sawF.A.IaH.lAxVNB@chimera>
Subject: [Bug #28422] kref and apparmor panic in 2.6.38-rc2.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Feb 2011 00:05:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (13 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2



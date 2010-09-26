Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0IZU3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 16:29:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab0IZU3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 16:29:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "rocko" <rockorequin@hotmail.com>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
In-Reply-To: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sQALkqF1FWE.A.gDE.ho6nMB@chimera>
Subject: [Bug #18992] warn_slow_path_common in iwlagn/mac80211 in 2.6.36-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Sep 2010 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=18992
Subject		: warn_slow_path_common in iwlagn/mac80211 in 2.6.36-rc5
Submitter	: rocko <rockorequin@hotmail.com>
Date		: 2010-09-23 03:07 (4 days old)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1BLXrw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:47:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1BLXnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:43:47 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Thomas=20B=C3=A4chler?=" <thomas@archlinux.org>
References: <9Pzlq5PlEtH.A.DU.efxVNB@chimera>
In-Reply-To: <9Pzlq5PlEtH.A.DU.efxVNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1z1FRILH7uF.A.O-.IgxVNB@chimera>
Subject: [Bug #27532] ath9k prevents CPU from entering lower C-states
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Feb 2011 00:38:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27532
Subject		: ath9k prevents CPU from entering lower C-states
Submitter	: Thomas Bächler <thomas@archlinux.org>
Date		: 2011-01-24 22:43 (20 days old)



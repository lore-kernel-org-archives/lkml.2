Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0GJAcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:32:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34540 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0GJAbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:31:52 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Jaroslav Kysela" <perex@perex.cz>,
       "=?utf-8?q?=C3=98yvind=20Stegard?=" <oyvinst@ifi.uio.no>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
In-Reply-To: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Hc02ROPrUsG.A.Bd.Fs7NMB@chimera>
Subject: [Bug #15912] Audio/video sync and crackling issues with snd-hda-intel (AD1981 codec)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 10 Jul 2010 02:33:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15912
Subject		: Audio/video sync and crackling issues with snd-hda-intel (AD1981 codec)
Submitter	: Øyvind Stegard <oyvinst@ifi.uio.no>
Date		: 2010-05-05 16:20 (66 days old)
Handled-By	: Jaroslav Kysela <perex@perex.cz>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0CUVBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:01:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59419 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0CUVBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:01:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alexandre Demers" <papouta@hotmail.com>,
       "Chris Wilson" <chris@chris-wilson.co.uk>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "=?utf-8?q?Kristian=20H=C3=B8gsberg?=" <krh@bitplanet.net>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
In-Reply-To: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hTwaxgnIZ2O.A.nHF.xPopLB@chimera>
Subject: [Bug #15259] Corruption with OpenGL since Intel's big DRM push on i945
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Mar 2010 21:30:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15259
Subject		: Corruption with OpenGL since Intel's big DRM push on i945
Submitter	: Alexandre Demers <papouta@hotmail.com>
Date		: 2010-02-08 13:19 (42 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/76446cac68568fc7f5168a27deaf803ed22a4360



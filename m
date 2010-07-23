Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab0GWMSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:18:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab0GWMSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:18:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Jaroslav Kysela" <perex@perex.cz>,
        "=?utf-8?q?=C3=98yvind=20Stegard?=" <oyvinst@ifi.uio.no>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
In-Reply-To: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PRbv8sgxY6G.A.owG.JXYSMB@chimera>
Subject: [Bug #15912] Audio/video sync and crackling issues with snd-hda-intel (AD1981 codec)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 14:15:49 +0200 (CEST)
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
Date		: 2010-05-05 16:20 (80 days old)
Handled-By	: Jaroslav Kysela <perex@perex.cz>



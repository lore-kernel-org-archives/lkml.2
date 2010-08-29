Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0H2Wwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 18:52:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab0H2WwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 18:52:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
In-Reply-To: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4AUWBNzTkbD.A.MO._FueMB@chimera>
Subject: [Bug #17021] [REGRESSION] [2.6.36-rc1] [DRM INTEL] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 00:36:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17021
Subject		: [REGRESSION] [2.6.36-rc1] [DRM INTEL] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2010-08-18 18:46 (12 days old)
Message-ID	: <201008182046.37732.maciej.rutecki@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128215721507666&w=2



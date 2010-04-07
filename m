Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0DGVtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:49:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0DGVtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:49:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Daniel Vetter" <daniel@ffwll.ch>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
In-Reply-To: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JVS2s9dmTsP.A.oc.ruPvLB@chimera>
Subject: [Bug #15518] CONFIG_NO_BOOTMEM=y breaks boot on 32bit
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  7 Apr 2010 23:13:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15518
Subject		: CONFIG_NO_BOOTMEM=y breaks boot on 32bit
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2010-03-11 15:37 (28 days old)



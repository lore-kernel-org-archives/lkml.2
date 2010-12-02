Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab0LBXlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:41:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab0LBXln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:41:43 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera>
In-Reply-To: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gUkHV_Vc3aE.A.NG.RzC-MB@chimera>
Subject: [Bug #22672] Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  3 Dec 2010 00:41:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22672
Subject		: Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2010-11-11 01:56 (22 days old)
References	: https://bugs.freedesktop.org/show_bug.cgi?id=31803
		  http://marc.info/?l=linux-kernel&m=128944001311444&w=2



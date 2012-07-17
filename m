Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2GQTSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:18:54 -0400
Received: from toro.web-alm.net ([62.245.132.31]:51541 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab2GQTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:18:45 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 15:18:44 EDT
Message-Id: <20120717185914.063547728@osadl.org>
User-Agent: quilt/0.51-1
Date: Tue, 17 Jul 2012 20:59:14 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Len Brown <len.brown@intel.com>
Cc: Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 0/1] cpuidle: allow to disable C states of the ladder governor 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when trying to disable a specific C state in order to improve the
idle responsiveness of a system but still enjoy some power saving,
we noted that writing to the related sysfs variable had no effect.

This patch allows to disable C states of the ladder governor.

	-Carsten.


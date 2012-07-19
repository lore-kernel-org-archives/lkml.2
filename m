Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2GSUuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:50:21 -0400
Received: from toro.web-alm.net ([62.245.132.31]:58312 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab2GSUuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:50:19 -0400
Message-Id: <20120719203409.398114351@osadl.org>
User-Agent: quilt/0.51-1
Date: Thu, 19 Jul 2012 22:34:09 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Rafael Wysocki <rjw@sisk.pl>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 0/1 v3] cpuidle: allow to disable C states of the ladder governor 
References: <201207192130.20520.rjw@sisk.pl> <201207192042.57935.rjw@sisk.pl> <20120719185212.184458166@osadl.org> <20120719190740.215034590@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

> Your patch doesn't seem to take this linux-next commit:

> http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=commit;h=dc7fd275ae60ef8edf952aff2a62462f5d892fd4

> into account, does it?
Hmm, oops, you're right. This one came in after I checked it last time.

Changes in v2: A note in the documentation explains why the sysfs
variable "disable" may not always reflect the current situation
and why modifying it may not always work as expected.

Changes in v3: The patch now applies to the current linux-next and
uses the per-cpu "disable" field.

	-Carsten.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1EFGpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:45:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:48885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab1EFGpA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:45:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,325,1301900400"; 
   d="scan'208";a="688991925"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Fri, 6 May 2011 14:43:18 +0800
Subject: [PATCH v2 0/2] x86: correct handle of percpu and disabled irqs in
 fixup_irqs
Thread-Topic: [PATCH v2 0/2] x86: correct handle of percpu and disabled irqs
 in fixup_irqs
Thread-Index: AcwLuNhBsSxielGEQjSHpFTAWiPD+Q==
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E1@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
	add a new patch to avoid unmasking disabled irq when doing affinity change.

[1/2] x86: skip migrating IRQF_PER_CPU irq in fixup_irqs
[2/2] x86: don't unmask disabled irqs when migrating them

Thanks
Kevin

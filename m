Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0GVQVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:21:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:55984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab0GVQVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:21:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,243,1278313200"; 
   d="scan'208";a="537865243"
Date: Thu, 22 Jul 2010 09:21:39 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Huaxu Wan <huaxu.wan@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: [PATCH 0/5] Package Level Thermal Control and Power Limit Notification
Message-ID: <20100722162139.GA21435@linux-os.sc.intel.com>
References: <493994B35A117E4F832F97C4719C4C048CAE2760@orsmsx505.amr.corp.intel.com> <E87738D94A6AD54789B5B8D1BAEB06CC6FFEE9ABF3@azsmsx503.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E87738D94A6AD54789B5B8D1BAEB06CC6FFEE9ABF3@azsmsx503.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new MSRs PACKAGE_THERM_STATUS and PACKAGE_THERM_INTERRUPT and power limit
notification are published in Intel 64 and IA32 SDM and first implemented on
Intel Sandy Bridge platform. The following patch set supports the new features
in Linux kernel. 

PATCH 1/5: Enable package level thermal management and power limit notification
PATCH 2/5: Package level thermal hwmon driver
PATCH 3/5: Package level thermal throttling support
PATCH 4/5: Power limit notification support
PATCH 5/5: Package level thermal hwmon driver doc



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1EXDYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:24:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:27091 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab1EXDYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:24:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,259,1304319600"; 
   d="scan'208";a="7532902"
Date: Tue, 24 May 2011 11:36:14 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        david.woodhouse@intel.com, akpm@linux-foundation.org, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com, hpa@linux.intel.com,
        allen.m.kay@intel.com, suresh.b.siddha@intel.com,
        rajesh.sankaran@intel.com, asit.k.mallick@intel.com,
        kent.liu@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v3] x86, vt-d: enable x2apic opt out
Message-ID: <20110524153614.GA19080@linux-youquan.bj.intel.com>
References: <1306161148-3987-1-git-send-email-youquan.song@intel.com> <7457.1306203521@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7457.1306203521@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we're doing a WARN level here, what are the downsides of just automagically
> forcing it rather than making them use a kernel parameter and reboot?  

As we have discussed before, x2apci opt out feature is requested from OEM that
they want to firmware tell OS to opt out x2apic when the platform,
hardware or BIOS is not ready to support x2apic. So we can not reboot or
force to use kernel parameter.  
But as David Woodhouse address that there are some researches about
disabling x2apic will be vulnerable to irq-injection attack, so we need
warn user about it. If user is sensitive to it, they also has alternative 
choice to ignore BIOS request by adding no_x2apic_optout kernel parameter.   

> Will some systems fail to boot because the BIOS was in fact right in requesting
No. we do not want system boot fail for BIOS requesting it.

Thanks
-Youquan


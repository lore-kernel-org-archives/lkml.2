Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1EKPhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:37:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:21107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1EKPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,353,1301900400"; 
   d="scan'208";a="925346"
Date: Wed, 11 May 2011 23:39:23 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>, rajesh.sankaran@intel.com,
        asit.k.mallick@intel.com
Subject: Re: [PATCH v2] x86, vt-d: enable x2apic opt out
Message-ID: <20110512033923.GA19708@linux-youquan.bj.intel.com>
References: <1302764783-24491-1-git-send-email-youquan.song@intel.com> <1305126431.30435.163.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305126431.30435.163.camel@i7.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Given that x2apic is *required* to be safe from irq injection tricks,
> why would we ever want to manually disable it?
> Is this just a workaround for a crappy BIOS? What is the *actual* reason
> for wanting to disable x2apic?

The VT-d 1.3 version specification add this new feature because OEM
request it. If OEM platform has issues to support x2apic or BIOS is 
buggy to support x2apic, there is alternative way to opt out x2apic. 

Refer to VT-d 1.3 specification Chpater 8.1.

Thanks
-Youquan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0K3SJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:09:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:10501 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab0K3SJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:09:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,281,1288594800"; 
   d="scan'208";a="862783379"
Subject: Re: [PATCH 0/2] Fix dmar fault interrupt problems
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>
In-Reply-To: <4CF4B597.4030708@jp.fujitsu.com>
References: <4CF4B597.4030708@jp.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 30 Nov 2010 10:09:13 -0800
Message-Id: <1291140553.2623.10.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 00:28 -0800, Kenji Kaneshige wrote:
> Hi,
> 
> Here are patches to fix the following problems regarding dmar fault interrupt.
> 
> - No dmar fault event is notified in x2apic cluster mode
> - Changing IRQ affinity of dmar fault interrupt causes "No irq handler
>   for vector (irq XX)" message and dmar fault interrupts are never
>   notified after that.

Kenji, In addition to these two, there are couple of more patches that
are needed to fix the kexec/kdump issue that we are debugging on RH
bugzilla.

I will post all these 4 patches shortly. I already noticed and queued
the second patch (dmar irq migration)  you mentioned.

thanks,
suresh


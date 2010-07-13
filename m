Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0GMDEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 23:04:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0GMDD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 23:03:59 -0400
Message-ID: <4C3BD6AA.3070908@kernel.org>
Date: Mon, 12 Jul 2010 19:59:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: tip/master broken with x2apic and kexec
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C3BD75D.00E7,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip/master: 
system1: BIOS enabled x2apic, first kernel boot well, and when kexec second kernel will cause system instant reboot.

system2: BIOS not enable x2apic, first kernel boot well and enable x2apic, and kexec second kernel well. but when kexec third kernel will case system instant reboot.

linus' tree is ok.

but for system2 if boot with nox2apic ,intr-remaping off, iommu off, the kexec loop test will pass.

the problem looks start in recent two or three weeks.

Any idea?

bisecting will take a while, because the system post take a while everytime.

Thanks

Yinghai Lu

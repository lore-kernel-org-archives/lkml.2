Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1HXHCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:02:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:52106 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1HXHCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:02:36 -0400
Message-ID: <4E54A0D9.7080306@kernel.org>
Date: Tue, 23 Aug 2011 23:57:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
        youquan.song@intel.com, joerg.roedel@amd.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] x86, msi, intr-remap: use the ioapic set affinity
 routine
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com> <20110824001456.452760446@sbsiddha-desk.sc.intel.com>
In-Reply-To: <20110824001456.452760446@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E54A0DC.0097,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 05:05 PM, Suresh Siddha wrote:
> IRQ set affinity routine is same for the IO-APIC IRQ's aswell as the MSI
> IRQ's in the presence of interrupt-remapping. This is because we modify
> the interrupt-remapping table entry and doesn't touch the IO-APIC RTE or the
> MSI entry.
> 
> So remove the ir_msi_set_affinity() and re-use the ir_ioapic_set_affinity()
> 

would be better to rename it to ir_set_affinity() ?

Yinghai

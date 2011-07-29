Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1G2WeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:34:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:52021 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1G2WeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:34:20 -0400
Message-ID: <4E333544.8080604@kernel.org>
Date: Fri, 29 Jul 2011 15:33:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] x86, ioapic: Clean up ioapic idx and apic id usage
References: <4E1F0BC9.1040102@kernel.org> <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com> <4E29BEEA.4020600@kernel.org> <20110725072831.GB22518@elte.hu>
In-Reply-To: <20110725072831.GB22518@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E33355B.0075,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check x86/ioapic clean up patches.

it will make sure ioapic_idx is used instead of ioapic or apic_idx to used as index.

[PATCH 1/5] x86, ioapic: Passing irq_attr struct pointer with setup_ioapic_irq()
[PATCH 2/5] x86, ioapic: Split setup_ioapic_entry for interrupt remapped version
[PATCH 3/5] x86, ioapic: Print out irte with right ioapic index
[PATCH 4/5] x86, ioapic: Seperate print_IO_APIC() to only print one io apic
[PATCH 5/5] x86, ioapic: Clean up ioapic/apic_id usage

patch1, 2, 4, 5 are cleanup related
patch3 fixes the one idx printout.

Thanks

Yinghai Lu

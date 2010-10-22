Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab0JVT3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:29:15 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:55374 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab0JVT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:29:12 -0400
Subject: [PATCH 0/2] x86, apic: APIC timer calibration hook
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 22 Oct 2010 12:29:12 -0700
Message-Id: <1287775752.27008.57.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We need a APIC calibration hook so that we can get the APIC frequency
directly from the hypervisor instead of calibrating it, since
calibration can be error prone in some cases when the kernel is running
virtualized. 

These patches were posted earlier over here
http://lkml.org/lkml/2010/9/20/424 to which Thomas did reply with some
comments. There was no activity of on the thread after some email
exchanges. I will like to post the 2 broken out patches for the 2.6.37
merge window. Please take a look and let me know if you have any
comments. 

1. Preparatory change to add apic timer calibration hook.
2. Adds apic timer calibration hook.

Thanks,
Alok


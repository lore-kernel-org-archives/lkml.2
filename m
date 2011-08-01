Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1HAQOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:14:24 -0400
Received: from mhub2.bbsrc.ac.uk ([149.155.202.2]:60715 "EHLO
	mhub2.bbsrc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1HAQOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:14:18 -0400
X-Greylist: delayed 1510 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Aug 2011 12:14:17 EDT
From: "dean north (BITS)" <dean.north@bbsrc.ac.uk>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 1 Aug 2011 16:49:01 +0100
Subject: Dell sx280 machine to graphics driver crash
Thread-Topic: Dell sx280 machine to graphics driver crash
Thread-Index: AcxQYohWe9uaCl93R+Wf/TZIPrGt3g==
Message-ID: <C57CE776344DFE4A8B8E254640024EE513D5E5277B@bitsexch1.bits.bbsrc.ac.uk>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I am currently installing the latest version of Fedora on an Dell Optiplex SX280.  The install works, Fedora boots fine and I can log in, but after a while the systems graphics driver crashes.  Below is an output of the issue.  It seems to be a bug in the Kernel

#
Aug 1 11:48:23 localhost kernel: [ 124.221008] [<f7a3780a>]
do_intel_finish_page_flip+0x16d/0x1f1 [i915] # Aug 1 11:48:23 localhost kernel: [ 124.221008] [<f7a3e09b>] intel_finish_page_flip_plane+0x1a/0x1c [i915] # Aug 1 11:48:23 localhost kernel: [ 124.221008] [<f7a2843b>]
i915_driver_irq_handler+0x884/0x942 [i915] # Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c07d62b3>] ?
_raw_spin_unlock_irqrestore+0x13/0x15 #
Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c06a1be1>] ?
__ata_sff_interrupt+0x126/0x137 #
Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c06a3735>] ?
ata_bmdma_port_intr+0x0/0xc2 #
Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c048704e>] handle_IRQ_event+0x4c/0xfe # Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c041c9fb>] ?
ack_apic_level+0x57/0x140 #
Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c0488b03>]
handle_fasteoi_irq+0x74/0xa6 #
Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c0488a8f>] ?
handle_fasteoi_irq+0x0/0xa6 #
Aug 1 11:48:23 localhost kernel: [ 124.221008] <IRQ> # Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c0404bbd>] ?
do_IRQ+0x3c/0x92 #
Aug 1 11:48:23 localhost kernel: [ 124.221008] [<c043feb7>] ?
irq_exit+0x4c/0x70


Dean North



This email and any attachments are intended solely for the use of the individual(s) to whom it/they are addressed. If you believe you have received this in error please notify the sender and delete this e-mail from your system.

BBSRC may need to release information, including this email and any attachments therein, under the terms of the Freedom of Information or Data Protection Acts.

Opinions, conclusions or other information in this message and attachments that are not related directly to BBSRC business are solely those of the author and do not represent the views of BBSRC.

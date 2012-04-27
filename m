Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2D0OeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:34:22 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:30276
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760223Ab2D0OeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:34:20 -0400
X-SpamScore: 0
X-BigFish: VPS0(zz4015Izz1202hzz8275eha1495iz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M35751-02-0SN-02
X-M-MSG: 
Date: Fri, 27 Apr 2012 16:34:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/2][RESEND] x86/pci/amd: Restore early_fill_mp_bus_to_node 
Message-ID: <20120427143410.GB27535@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am resending this two patches as the old submission faced starvation

http://marc.info/?l=linux-pci&m=133338730115350&w=2

(Guess this was due to the switch in PCI maintenance.)

The main purpose of the two patches is to correctly set the numa_node
attribute of PCI devices on systems with AMD Interlagos CPUs.

Please apply.


Thanks,

Andreas



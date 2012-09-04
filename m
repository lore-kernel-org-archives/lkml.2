Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2IDIZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:25:31 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:27619 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab2IDIZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:25:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9TGQ9-01-71C-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Renninger <trenn@suse.de>
CC: Matthew Garret <mjg@redhat.com>, <linux-pm@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH 0/8 v2] acpi-cpufreq: Move modern AMD cpufreq support to acpi-cpufreq
Date: Tue, 4 Sep 2012 10:28:01 +0200
Message-ID: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

now the second, revised version of the patch set. I now tested loading
both drivers after each other in several combinations, after two bug
fixes this now works as expected.
I added a patch to move messages from powernow-k8 after the initialization
phase, so it remains silent if driver loading fails.

I also rearranged the patches so that the powernow-k8 feature removal patch is
now the last one and is somewhat optional. I still prefer to have it in,
but it can be dropped if needed. Then powernow-k8 will still support modern
AMD CPUs, but will emit a warning message.

Regards,
Andre

Changes from v1:
* added hints to Kconfig about CPU support
* merge documentation from separate patch into the feature patch
* add deprecation warning
* prefix acpi-cpufreq warning messages with module name
* bugfix: avoid boost init it driver registration failed
* bugfix: fix module redirect request call (was not reached before)




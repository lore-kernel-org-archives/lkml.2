Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2GZM24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:28:56 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:24226
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab2GZM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:28:53 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RPBY-01-D15-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 0/8] acpi-cpufreq: Move modern AMD cpufreq support to acpi-cpufreq
Date: Thu, 26 Jul 2012 14:28:36 +0200
Message-ID: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The programming model for cpufreq on current AMD CPUs is almost identical
to the one used on Intel and VIA hardware. This patchset merges support
into acpi-cpufreq and removes it from powernow-k8.

This patchset is heavily based on Matthew Garrett's V4 from last July.
The boosting part has been mostly reworked and documentation for it
has been added. Also there was a need for (yet another) BIOS quirk
on AMD desktop boards.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>



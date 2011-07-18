Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1GRQiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1GRQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:38:16 -0400
From: Matthew Garrett <mjg@redhat.com>
To: cpufreq@vger.kernel.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        mark.langsdorf@amd.com, andreas.herrmann3@amd.com
Subject: [PATCH v4] Move modern AMD cpufreq support to acpi-cpufreq 
Date: Mon, 18 Jul 2011 12:37:35 -0400
Message-Id: <1311007062-2050-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The programming model for cpufreq on current AMD CPUs is almost identical
to the one used on Intel and VIA hardware. This patchset merges support
into acpi-cpufreq and removes it from powernow-k8. V4 addresses all the 
review feedback received so far.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab0HKRDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab0HKRDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:03:52 -0400
Date: Wed, 11 Aug 2010 12:35:05 -0400
From: Dave Jones <davej@redhat.com>
To: apw@canonical.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: checkpatch false positive.
Message-ID: <20100811163505.GB26497@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, apw@canonical.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got this from a patch I merged..

ERROR: need consistent spacing around '*' (ctx:WxV)
#121: FILE: arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c:113:
+static struct pcc_cpu __percpu *pcc_cpu_info;
                                ^
which doesn't seem right.

	Dave


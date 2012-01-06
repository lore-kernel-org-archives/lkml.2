Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2AFOzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:55:10 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25283
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758734Ab2AFOzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:55:08 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LXDTFL-02-5QN-02
X-M-MSG: 
Date: Fri, 6 Jan 2012 15:55:00 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Dave Jones <davej@redhat.com>
CC: <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] powernow-k8: Misc fixes
Message-ID: <20120106145500.GI24451@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Following two fixes are required on systems where intermediate Pstates
are disabled.

Please apply.


Thanks,

Andreas



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab1FPUOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:14:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27561 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab1FPUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:14:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, cpufreq@vger.kernel.org,
        davej@redhat.com, bp@alien8.de, Mark.Langsdorf@amd.com,
        andre.przywara@amd.com
Subject: [PATCH]/[GIT PULL] stable/cpufreq.bugfixes for 3.0 for cpufreq fixes.
Date: Thu, 16 Jun 2011 15:36:37 -0400
Message-Id: <1308253000-6289-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DFA6422.0060:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dave,

This is a follow up after the initial posting (http://www.gossamer-threads.com/lists/linux/kernel/1394515).

The first patch:
 [PATCH 1/3] [CPUFREQ]: Don't set stat->last_index to -1 if the pol->cur has incorrect value.

is exactly like the first posting, while the second (old) patch was split in two:

 [PATCH 2/3] [CPUFREQ] powernow-k8: Don't notify of successful transition if we failed (vid case).

and the pstate transition code was augmented a bit more:

 [PATCH 3/3] [CPUFREQ] powernow-k8: Don't try to transition if the pstate is incorrect

Also Borislav Acked and reviewed the patches.

Please either:

a). git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/cpufreq.bugfixes

b) or git am this email thread.

I don't know which way you prefer. The patches have been rebased on top of v3.0-rc3 tag.

Thank you!


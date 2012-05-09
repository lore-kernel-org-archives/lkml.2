Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2EII0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2EII0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:26:40 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, imammedo@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: [PATCH 0/5] [x86]: Improve secondary CPU bring-up process robustness
Date: Wed,  9 May 2012 12:24:57 +0200
Message-Id: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Target audience for this patches is mostly virt. environments, where
physical CPUs are shared beetween many guests and on overcommited
host it can uncover different race conditions during secondary CPU
bring-up.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>

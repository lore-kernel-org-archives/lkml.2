Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030828Ab2CFOtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:49:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759273Ab2CFOti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:49:38 -0500
Subject: nommu build failure in linux-next
From: Mark Salter <msalter@redhat.com>
To: siddhesh.poyarekar@gmail.com
Cc: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 06 Mar 2012 09:49:36 -0500
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331045377.17099.2.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b7b2a0afacada237005068294cb0ccc49d32889e
Author: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Date:   Tue Mar 6 11:17:12 2012 +1100

    procfs: mark thread stack correctly in proc/<pid>/maps


This patch still breaks nommu builds. The previous syntax issue has been
resolved, but now I see a link error:

fs/built-in.o: In function `nommu_vma_show':
task_nommu.c:(.text+0x564a0): undefined reference to `vm_is_stack'
make[1]: *** [.tmp_vmlinux1] Error 1




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2HFRAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:00:45 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57558 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716Ab2HFRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:00:43 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v1 0/4] x86, CPU: TLB flushall shift, the AMD side
Date: Mon,  6 Aug 2012 19:00:35 +0200
Message-Id: <1344272439-29080-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

here's v1 with hpa's suggested changes.

Changelog:

* v0:

now that the Intel TLB subset flushing patches are in mainline, here's
the AMD side of the deal.

Those have been tested on all our families with the mprotect
microbenchmark. Any comments are appreciated.

Thanks.

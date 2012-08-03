Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2HCQis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:38:48 -0400
Received: from osrc3.amd.com ([217.9.48.20]:47866 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab2HCQiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:38:03 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/4] x86, CPU: TLB flushall shift, the AMD side
Date: Fri,  3 Aug 2012 18:37:45 +0200
Message-Id: <1344011869-21868-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

now that the Intel TLB subset flushing patches are in mainline, here's
the AMD side of the deal.

Those have been tested on all our families with the mprotect
microbenchmark. Any comments are appreciated.

Thanks.

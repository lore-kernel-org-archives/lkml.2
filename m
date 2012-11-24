Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2KXIb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:31:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2KXIb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:26 -0500
Message-Id: <20121124082918.671430919@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:18 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] several selftests fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew:

Here is several fixes for selftests.
For `make run_tests` the target command will cause make fail if it exit
with non zero codes. So I change the makefile as below:
 run_tests: all
-       /bin/sh ./run_vmtests
+       @/bin/sh ./run_vmtests || echo "vmtests: [FAIL]"

Also fixed the kcmp build error.

--
Thanks
Dave

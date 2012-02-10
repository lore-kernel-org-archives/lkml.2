Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab2BJOqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:46:54 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22442 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089Ab2BJOqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:46:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] vcpu hotplug fix for v3.3-rc3 (v1).
Date: Fri, 10 Feb 2012 09:43:52 -0500
Message-Id: <1328885033-8450-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F352DDA.012C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When playing with xl/xm vcpu-set I found out that Linux 3.3 has a bunch of problems.
Some of them were in generic code base (patches for that are queued up by Greg KH),
and some were in the Xen base. Previously I had posted:

    xen/smp: Fix CPU online/offline bug triggering a BUG: scheduling while atomic.
    xen/bootup: During bootup suppress XENBUS: Unable to read cpu state

and this is meant to be on top of those to make vCPU hotplugging work properly
with 3.3 kernel. Some of those should be back-ported to 3.0 but I am not sure
which ones (and if there are other ones as well) so won't do that until I get some time
to do a proper testing of them on v3.0.

If you want to full kitchensink, please see #testing branch. If you just want
to see those patches above (and others queued up for 3.3-rc3), take a look at
#stable/for-linus-fixes-3.3 in git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git



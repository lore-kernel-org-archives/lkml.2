Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0G0UsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab0G0UsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:48:21 -0400
Date: Tue, 27 Jul 2010 23:42:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Make vhost multi-threaded and associate each thread to its guest's
 cgroup
Message-ID: <20100727204254.GA17947@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sridhar,
I pushed a patchset with all known issues fixed,
on my vhost-net-next branch.

For now this ignores the cpu mask issue, addressing
only the cgroups issue.

Would appreciate testing and reports.

Thanks,
-- 
MST

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2INOdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:33:16 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:35475 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab2INOdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:33:07 -0400
From: Daniel Wagner <wagi@monom.org>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Joe Perches <joe@perches.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Li Zefan <lizefan@huawei.com>, Neil Horman <nhorman@tuxdriver.com>,
        Rick Jones <rick.jones2@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Tejun Heo <tj@kernel.org>, netdev@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: [PATCH] Fix for "cgroup: Assign subsystem IDs during compile time"
Date: Fri, 14 Sep 2012 16:33:02 +0200
Message-Id: <1347633184-26837-1-git-send-email-wagi@monom.org>
X-Mailer: git-send-email 1.7.12.315.g682ce8b
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Hi, 

Sorry for breaking Tejun's cgroup for-3.7 branch. Here are two patches
which fix this problem. Either of them will do. 

cheers,
daniel

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Rick Jones <rick.jones2@hp.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: netdev@vger.kernel.org
Cc: cgroups@vger.kernel.org

-- 
1.7.12.315.g682ce8b


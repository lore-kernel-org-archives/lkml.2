Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0G1BdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 21:33:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0G1BdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 21:33:02 -0400
Date: Wed, 28 Jul 2010 04:27:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, dlstevens@us.ibm.com
Subject: vhost mergeable buffers guest's cgroup
Message-ID: <20100728012735.GA23243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sridhar, David,
I pushed a mergeable buffers patchset on my vhost-net-next branch,
on top of the threading changes.
 
This is a minimal patch, which in my testing has zero impact on
non-mergeable path.

Please give this a spin and let me know.

Thanks!

-- 
MST

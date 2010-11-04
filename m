Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0KDL0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 07:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab0KDL0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:26:42 -0400
Date: Thu, 4 Nov 2010 13:26:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: krkumar2@in.ibm.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: vhost-net-next updates
Message-ID: <20101104112630.GA28748@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pushed out some optimization patches on vhost-net-next
branch on my vhost tree (intended for 2.6.38).
It would be helpful if people working on vhost-net optimizations
base their work on that tree just to make sure comparisons
are apples to apples.

I might rebase this as I didn't send a pull request to Dave yet
but I'll try not to.  So far I have:

8b7347a vhost: get/put_user -> __get/__put_user
dfe5ac5 vhost: copy_to_user -> __copy_to_user
64e1c80 vhost-net: batch use/unuse mm
533a19b vhost: put mm after thread stop
3fcedec drivers/vhost/vhost.c: delete double assignment

Thanks!

-- 
MST

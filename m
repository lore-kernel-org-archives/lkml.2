Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1ANJdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:33:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab1ANJdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:33:24 -0500
Date: Fri, 14 Jan 2011 11:33:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL] vhost-net: 2.6.38 fix
Message-ID: <20110114093302.GA702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following for 2.6.38.
Thanks!

The following changes since commit 0c21e3aaf6ae85bee804a325aa29c325209180fd:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus (2011-01-07 17:16:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Michael S. Tsirkin (1):
      vhost: fix signed/unsigned comparison

 drivers/vhost/vhost.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

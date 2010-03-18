Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0CRKAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:00:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0CRKAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:00:30 -0400
Date: Thu, 18 Mar 2010 11:53:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, kvm@vger.kernel.org, virtualization@lists.osdl.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       samudrala@us.ibm.com, Jiri Slaby <jirislaby@gmail.com>,
       Laurent Chavey <chavey@google.com>, Juan Quintela <quintela@redhat.com>,
       Unai Uribarri <unai.uribarri@optenet.com>,
       Jeff Dike <jdike@linux.intel.com>
Subject: [GIT PULL] vhost-net fixes for issues in 2.6.34-rc1
Message-ID: <20100318095355.GA24194@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
The following tree includes patches fixing issues with vhost-net in
2.6.34-rc1.  Please pull them for 2.6.34.
 
Thanks!

The following changes since commit a3d3203e4bb40f253b1541e310dc0f9305be7c84:

  Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6 (2010-03-14 20:29:21 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost

Jeff Dike (1):
      vhost: fix error path in vhost_net_set_backend

Michael S. Tsirkin (2):
      vhost: fix interrupt mitigation with raw sockets
      vhost: fix error handling in vring ioctls

 drivers/vhost/net.c   |   10 ++++++----
 drivers/vhost/vhost.c |   18 ++++++++++++------
 2 files changed, 18 insertions(+), 10 deletions(-)

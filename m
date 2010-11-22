Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab0KVXVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:21:16 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:7402 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab0KVXVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:21:15 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,239,1288569600"; 
   d="scan'208";a="290719278"
Date: Mon, 22 Nov 2010 15:21:24 -0800
From: Tom Lyon <pugs@cisco.com>
To: linux-pci@vger.kernel.org, mbranton@gmail.com, alexey.zaytsev@gmail.com,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org, alex.williamson@redhat.com, mst@redhat.com
Subject: [ANNOUNCE] VFIO V6 & public VFIO repositories
Message-ID: <4ceafaf4.pffTeLx1ndqdBH3c%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO "driver" development has moved to a publicly accessible respository
on github:

	git://github.com/pugs/vfio-linux-2.6.git

This is a clone of the Linux-2.6 tree with all VFIO changes on the vfio 
branch (which is the default). There is a tag 'vfio-v6' marking the latest
"release" of VFIO.

In addition, I am open-sourcing my user level code which uses VFIO.
It is a simple UDP/IP/Ethernet stack supporting 3 different VFIO based
hardware drivers. This code is available at:

	git://github.com/pugs/vfio-user-level-drivers.git

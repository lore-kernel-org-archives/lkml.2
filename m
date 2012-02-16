Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2BPOyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:54:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab2BPOyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:54:43 -0500
Date: Thu, 16 Feb 2012 16:54:49 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RFC: export constants from shpc.h?
Message-ID: <20120216145447.GA25979@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've implemented an shpc controller emulator
in qemu, so I needed a bunch of constants
similar to what drivers/pci/hotplug/shpc.h has.

Any objections to adding a PCI_SHPC_XXXX prefix
so these and moving them to pci_regs.h?
PCI utilities can then use them from /usr/include/linux.

One can see how a utility that looks at slot LED and MRL
states might be useful
(we'd need to export the base offset through sysfs
to make it possible to use such in parallel with shpc).

-- 
MST


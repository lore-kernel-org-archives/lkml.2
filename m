Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1DSVnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:43:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1DSVnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:43:19 -0400
Date: Tue, 19 Apr 2011 14:43:01 -0700
From: Chris Wright <chrisw@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alex Williamson <alex.williamson@redhat.com>, pugs@ieee.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        qemu-devel@nongnu.org, chrisw@redhat.com, aafabbri@cisco.com,
        dwang2@cisco.com, benve@cisco.com
Subject: Re: [PATCH] vfio: Add an ioctl to reset the device
Message-ID: <20110419214301.GN12133@x200.localdomain>
References: <20110419203234.4254.94914.stgit@s20.home>
 <20110419144023.4d3f61da.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419144023.4d3f61da.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (rdunlap@xenotime.net) wrote:
> I can't find include/linux/vfio.h in linux-next or mainline git, but
> ioctls need to be documented in Documentation/ioctl/ioctl-number.txt....

It is in the full patchset: https://github.com/pugs/vfio-linux-2.6

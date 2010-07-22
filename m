Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0GVSI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:08:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41780 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0GVSI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:08:56 -0400
Date: Thu, 22 Jul 2010 12:08:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Filesystem hints to storage
Message-ID: <20100722180854.GB22009@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The NVMHCI working group has specified [1] a set of attributes for
filesystems to pass down to devices which may allow the device to lay
out its storage more effectively (eg if it's a hybrid MLC/SLC device).

For Enterprise NVMHCI, the working group is looking at refining these
hints.  Are there any hints that people would like to see added or
removed from the list in NVMHCI 1.0?

I think there are some hints that are hard for the filesystem to know
itself, never mind pass down, so it'd be good to remove them to reduce
the complexity.  Contrariwise, there are some hints I think the filesystem
could pass down that aren't in the spec today, such as the flags from
madvise (random access vs sequential access) and whether the access is
for fs metadata or application data.

[1] http://www.intel.com/standards/nvmhci/index.htm
Page 35, figure 26

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

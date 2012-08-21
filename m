Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2HUKye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:54:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53672 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2HUKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:54:29 -0400
Date: Tue, 21 Aug 2012 14:54:24 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120821105424.GA7670@moon>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <87fw7habo4.fsf@skywalker.in.ibm.com>
 <20120820163338.GN23596@moon>
 <20120820183225.GB4911@fieldses.org>
 <20120820190606.GE27443@moon>
 <20120820193204.GD5779@fieldses.org>
 <50335261.5090504@parallels.com>
 <87wr0sle4v.fsf@skywalker.in.ibm.com>
 <503367CB.9080609@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503367CB.9080609@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:49:47PM +0400, Pavel Emelyanov wrote:
> >>
> >> However, if you have some better ideas on what information about inode should be exported
> >> to the userspace please share.
> >>
> > 
> > Why not use name_to_handle(fd,...) and open_by_handle(handle,..) ?
> 
> Because we don't have an fd at hands by the time we need to know the handle.

Yeah, this might be not clear from patchset itself but inotify marks carry
inodes inside kernel thus it's inodes what we can use when we fetch information
about targets and put it into fdinfo output.

	Cyrill

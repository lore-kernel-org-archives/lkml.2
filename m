Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2KTGgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:36:06 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37347 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2KTGgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:36:04 -0500
Date: Tue, 20 Nov 2012 10:35:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
Message-ID: <20121120063559.GA31306@moon>
References: <20121114151937.344922058@openvz.org>
 <20121114152239.936025193@openvz.org>
 <20121116155603.2118394c.akpm@linux-foundation.org>
 <20121117071039.GA22855@moon>
 <20121117083437.GC22855@moon>
 <20121119164938.7f19f3d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119164938.7f19f3d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 04:49:38PM -0800, Andrew Morton wrote:
> 
> Where *is* this pseudo-file, anyway?  The changelog doesn't tell us
> where it lies in the filesystem.
> 
> I know!  I'll search the documentation!  /proc/sys/fs/epoll/..., yes?
> 
> btw, Documentation/sysctl/fs.txt is missing documentation for
> max_user_instances and max_queued_events.  Perhaps you can fix that
> when providing the documentation changes for your patch :)

Sure, I'll provide the docs patch on top. Thanks!

	Cyrill

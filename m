Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab2HUMwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:52:11 -0400
Received: from natasha.panasas.com ([67.152.220.90]:36646 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2HUMwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:52:09 -0400
Message-ID: <50338458.7090602@panasas.com>
Date: Tue, 21 Aug 2012 15:51:36 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Pavel Emelyanov <xemul@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120820183225.GB4911@fieldses.org> <20120820190606.GE27443@moon> <20120820193204.GD5779@fieldses.org> <50335261.5090504@parallels.com> <87wr0sle4v.fsf@skywalker.in.ibm.com> <503367CB.9080609@parallels.com> <20120821105424.GA7670@moon> <50336C51.60501@parallels.com> <20120821121155.GC9483@fieldses.org> <50337D87.90607@parallels.com> <20120821122908.GE9483@fieldses.org>
In-Reply-To: <20120821122908.GE9483@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 03:29 PM, J. Bruce Fields wrote:
<>

> OK.  So if you don't mind the fact that there are filesystems with
> inotify support but not filehandle support, then I think generating a
> filehandle early as you describe would work.  I guess it's a little more
> memory per watched inode.
> 


For the minority of FSs that do not have a filehandle support it should
be easy to generate a generic one, that should work 95% of the time.

Are we guaranteed that after the checkpoint restore the version of
the Kernel is the same as the one that did the checkpoint? If yes
then I don't see any problem.

> --b.


Cheers
Boaz


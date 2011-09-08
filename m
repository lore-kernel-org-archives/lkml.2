Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab1IHJgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:36:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44839 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758128Ab1IHJgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:36:14 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: agruen@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 11/26] vfs: Add permission flags for setting file attributes
In-Reply-To: <20110907205503.GG8074@fieldses.org>
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1315243548-18664-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20110907205503.GG8074@fieldses.org>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Thu, 08 Sep 2011 15:06:03 +0530
Message-ID: <87d3fb5qbg.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11090809-6078-0000-0000-0000007B0152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011 16:55:03 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Mon, Sep 05, 2011 at 10:55:33PM +0530, Aneesh Kumar K.V wrote:
> > From: Andreas Gruenbacher <agruen@kernel.org>
> > 
> > Some permission models can allow processes to take ownership of a file,
> > change the file permissions, and set the file timestamps.  Introduce new
> > permission mask flags and check for those permissions in
> > inode_change_ok().
> 
> These little helper functions seem like they might be reasonable cleanup
> even without the richacl_change_ok() piece; wonder if it'd be worth
> splitting out the cleanup and applying it now?
> 
> Not that it's necessary--seems like a straightforward enough patch as
> is.

Those helpers also have richacl_chage_ok(..) done as a part of the call. So
they cannot directly be applied to upstream. But we can do similar
helpers for upstream and add richacl changes as a separate patch ? Is
that what you are suggesting. I can split this patch to two in that case

-aneesh


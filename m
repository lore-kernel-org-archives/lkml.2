Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1BMUUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:20:41 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29762 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1BMUUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:20:34 -0500
Date: Sun, 13 Feb 2011 21:19:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Hefty, Sean" <sean.hefty@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.co.il>, Julia Lawall <julia@diku.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Roland Dreier <roland@kernel.org>
Subject: RE: [PATCH][RFC] infiniband: Fix allocation size in
 register_snoop_agent()
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC45047A@orsmsx501.amr.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1102132119080.18930@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102112237490.16994@swampdragon.chaosbits.net> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC45047A@orsmsx501.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Hefty, Sean wrote:

> > Ok, someone needs to double check me on this before merging anything, but
> > don't we want to allocate sizeof(struct ib_mad_snoop_private) here, rather
> > than just the size of a pointer to the struct?
> 
> new_snoop_table is declared as:
> 
> struct ib_mad_snoop_private **new_snoop_table;
> 
> It should point to an array of pointers.
> 
Ok. Thank you for that reply.
Just ignore the patch then.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html


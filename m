Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0CWLzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:55:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0CWLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:55:16 -0400
Date: Tue, 23 Mar 2010 07:55:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: zhou peng <ailvpeng25@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: About ACL for IPC Object
Message-ID: <20100323115513.GA7751@infradead.org>
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com> <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com> <4B57C3C3.9010606@schaufler-ca.com> <6fb445941003230201r656d0363k6ed6853c3edc826b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fb445941003230201r656d0363k6ed6853c3edc826b@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 05:01:31PM +0800, zhou peng wrote:
> Hi,
> 
> I have added ACL support to POSIX msg queue on linux kernel 2.6.32.
> Casey Schaufler, would you or anyone like review the patch for me please?
> The patch is attached.

There is quite a lot of boilerplate code in the patch.  You might want
to take a look at fs/generic_acl.c and how mm/shmem.c uses it to get
away with a lot less code.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2HUNNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:13:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40408 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2HUNNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:13:08 -0400
Date: Tue, 21 Aug 2012 14:12:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120821131253.GJ23464@ZenIV.linux.org.uk>
References: <20120820193204.GD5779@fieldses.org>
 <50335261.5090504@parallels.com>
 <87wr0sle4v.fsf@skywalker.in.ibm.com>
 <503367CB.9080609@parallels.com>
 <20120821105424.GA7670@moon>
 <50336C51.60501@parallels.com>
 <20120821121155.GC9483@fieldses.org>
 <50337D87.90607@parallels.com>
 <20120821122908.GE9483@fieldses.org>
 <50338458.7090602@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50338458.7090602@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 03:51:36PM +0300, Boaz Harrosh wrote:
> For the minority of FSs that do not have a filehandle support it should
> be easy to generate a generic one, that should work 95% of the time.

Great.  Your task, then, is to show how to do that for sysfs.  Or for nfs.
Those should be representative enough for you to get the appropriate
reality check.

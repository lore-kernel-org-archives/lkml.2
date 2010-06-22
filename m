Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0FVOnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:43:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0FVOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:43:31 -0400
Date: Tue, 22 Jun 2010 10:43:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@Sun.COM, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: Re: [PATCH V3 3/8] Cleancache: core ops functions and configuration
Message-ID: <20100622144320.GA13324@infradead.org>
References: <20100621231939.GA19505@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621231939.GA19505@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 04:19:39PM -0700, Dan Magenheimer wrote:
> [PATCH V3 3/8] Cleancache: core ops functions and configuration
> 
> Cleancache core ops functions and configuration

NACK for code that just adds random hooks all over VFS and even
individual FS code, does an EXPORT_SYMBOL but doesn't actually introduce
any users.

And even if it had users these would have to be damn good ones given how
invasive it is.  So what exactly is this going to help us?  Given your
affiliation probably something Xen related, so some real use case would
be interesting as well instead of just making Xen suck slightly less.


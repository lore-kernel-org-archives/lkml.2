Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0FBNYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:24:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab0FBNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:24:50 -0400
Date: Wed, 2 Jun 2010 09:24:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: Re: [PATCH V2 0/7] Cleancache (was Transcendent Memory): overview
Message-ID: <20100602132427.GA32110@infradead.org>
References: <20100528173510.GA12166@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528173510.GA12166@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please give your patches some semi-resonable subject line.

>  fs/btrfs/super.c           |    2 
>  fs/buffer.c                |    5 +
>  fs/ext3/super.c            |    2 
>  fs/ext4/super.c            |    2 
>  fs/mpage.c                 |    7 +
>  fs/ocfs2/super.c           |    3 
>  fs/super.c                 |    8 +

This is missing out a whole lot of filesystems.  Even more so why the
hell do you need hooks into the filesystem?


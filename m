Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2B0C16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 21:27:58 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:36827 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2B0C15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 21:27:57 -0500
Date: Sun, 26 Feb 2012 19:04:28 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, linux-ext4@kernel.org
Subject: Re: [PATCH 66/73] ext2: Split ext2_add_entry() from
 ext2_add_link() [ver #2]
Message-ID: <20120227000428.GA8044@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, valerie.aurora@gmail.com,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@kernel.org
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <20120221180546.25235.50961.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221180546.25235.50961.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 06:05:46PM +0000, David Howells wrote:
> From: Valerie Aurora <vaurora@redhat.com>
> 
> Allow future code to use the guts of ext2_add_link().
> 
> Original-author: Valerie Aurora <vaurora@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@kernel.org

I'd suggest folding this in with the following patch (67/73).  It's
not clear from this patch why renaming ext2_add_link to
ext2_add_entry() makes sense and then adding a new ext2_add_link()
which calls ext_add_entry().   It doesn't seem to clarify much....

I won't insist on it, but this seems to be unnecessary complication.

      	    		       	  	       - Ted

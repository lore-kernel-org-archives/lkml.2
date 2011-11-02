Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1KBB7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:59:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60842 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1KBB7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:59:36 -0400
Date: Tue, 1 Nov 2011 21:59:29 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] ext4: fix printk format warning in page-io
Message-ID: <20111102015929.GP32161@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
 <4EB08189.2@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB08189.2@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:32:25PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warning:
> 
> fs/ext4/page-io.c:108:5: warning: format '%d' expects type 'int', but argument 6 has type 'ssize_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	"Theodore Ts'o" <tytso@mit.edu>
> Cc:	Andreas Dilger <adilger.kernel@dilger.ca>
> Cc:	linux-ext4@vger.kernel.org

Thanks, I'll get this fixed before I send my pull request.

	     	      	    	     	  - Ted

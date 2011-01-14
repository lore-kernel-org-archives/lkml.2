Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1ANWfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:35:44 -0500
Received: from THUNK.ORG ([69.25.196.29]:44539 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab1ANWfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:35:43 -0500
Date: Fri, 14 Jan 2011 17:35:25 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: clearcache (Was: Re: [git pull] vfs pile 1)
Message-ID: <20110114223525.GA20593@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20110113053554.GQ19804@ZenIV.linux.org.uk>
 <20110113172557.c016ec51.sfr@canb.auug.org.au>
 <20110113085547.GA7414@infradead.org>
 <20110113214239.1b23b523.sfr@canb.auug.org.au20110113220039.GF31800@thunk.org>
 <7aa3a707-4713-41ca-b9f1-327485774722@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aa3a707-4713-41ca-b9f1-327485774722@default>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 01:11:02PM -0800, Dan Magenheimer wrote:
> As a result, I've spent most of my
> free time over the last three months working on kztmem, which will
> hopefully serve the purpose.

You'll have to forgive me, but I have absolutely no idea what kztmem
is or what it does.  Is it just compressed tmem, and hence, something
that is only of interest to people using Xen?  If so, it's not clear
to me how it will help non-Xen people become interested in these
patches.

Regards,

					- Ted

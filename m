Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab1KVU7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:59:33 -0500
Received: from fieldses.org ([174.143.236.118]:47815 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758453Ab1KVU7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:59:32 -0500
Date: Tue, 22 Nov 2011 15:59:30 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH] nfsd: Fix oops when parsing a 0 length export
Message-ID: <20111122205930.GG21451@fieldses.org>
References: <1321611289-21809-1-git-send-email-levinsasha928@gmail.com>
 <20111122202817.GD21451@fieldses.org>
 <1321994009.3787.19.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321994009.3787.19.camel@lappy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:33:29PM +0200, Sasha Levin wrote:
> On Tue, 2011-11-22 at 15:28 -0500, J. Bruce Fields wrote:
> > On Fri, Nov 18, 2011 at 12:14:49PM +0200, Sasha Levin wrote:
> > > expkey_parse() oopses when handling a 0 length export. This is easily
> > > triggerable from usermode by writing 0 bytes into
> > > '/proc/[proc id]/net/rpc/nfsd.fh/channel'.
> > 
> > Thanks--how did you run across this?
> > 
> > --b.
> 
> Tried running a fuzzer on the system.

OK, thanks.  As far as I can tell this could only be hit by a privileged
user doing something stupid.  And the bug has been there forever.

So I'm inclined just to queue this up for 3.3.

--b.

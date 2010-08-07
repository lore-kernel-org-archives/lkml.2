Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808Ab0HGGsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:48:04 -0400
Received: from THUNK.ORG ([69.25.196.29]:36543 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0HGGsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:48:00 -0400
Date: Sat, 7 Aug 2010 02:47:56 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ext4 tree
Message-ID: <20100807064756.GE28087@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100807124515.d26dc4e0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807124515.d26dc4e0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 12:45:15PM +1000, Stephen Rothwell wrote:
> Hi Ted,
> 
> After merging the ext4 tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> fs/jbd2/transaction.c: In function 'start_this_handle':
> fs/jbd2/transaction.c:98: warning: unused variable 'ts'
> 
> Introduced by commit 8dd420466c7bfc459fa04680bd5690bfc41a4553 ("jbd2:
> Remove t_handle_lock from start_this_handle()") which modev the only uses
> of this variable inside a section of code protected by CONFIG_JBD2_DEBUG.

Thanks for pointing this out.  I'll fix this up in the future (at the
moment I'm waiting for Linus to take a pull).

       	   	       	     	       - Ted

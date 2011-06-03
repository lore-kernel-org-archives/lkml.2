Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1FCOSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:18:41 -0400
Received: from twin.jikos.cz ([89.185.236.188]:48819 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab1FCOSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:18:39 -0400
Date: Fri, 3 Jun 2011 16:17:56 +0200
From: David Sterba <dave@jikos.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        David Sterba <dave@jikos.cz>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning from Linus' tree
Message-ID: <20110603141756.GT12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
	David Sterba <dave@jikos.cz>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Linus <torvalds@linux-foundation.org>
References: <20110603111049.d5967bb3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603111049.d5967bb3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 03, 2011 at 11:10:49AM +1000, Stephen Rothwell wrote:
> fs/btrfs/delayed-inode.c: In function 'btrfs_batch_insert_items':
> fs/btrfs/delayed-inode.c:670:6: warning: 'nitems' may be used uninitialized in this function
> 
> Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
> operation").  I think this is a real bug.  This variable is not
> initialised, only incremented and tested.

yes, it's a bug and has been already hit (fix pending):

http://marc.info/?l=linux-btrfs&m=130678270307885&w=4

thanks,
david

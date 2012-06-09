Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2FICiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:38:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48676 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab2FICiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:38:13 -0400
Date: Fri, 8 Jun 2012 22:38:04 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120609023804.GC14153@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
 <20120608202840.GB1704@thunk.org>
 <20120608233728.GA7691@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608233728.GA7691@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 08:37:28AM +0900, Fengguang Wu wrote:
> 
> Here is the updated changelog:
> 
>         writeback: Fix lock imbalance in writeback_sb_inodes()
> 
>         Fix bug introduced by 169ebd90.  We have to have wb_list_lock locked when
>         restarting writeback loop after having waited for inode writeback.
> 
>         Bug description by Ted Tso:
>           
>           I can reproduce this fairly easily by using ext4 w/o a journal, running
>           under KVM with 1024megs memory, with fsstress (xfstests #13):

Not that it matters that much, but I typo'ed the description; sorry
about that.  The KVM only had 1024k of memory....

						- Ted

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2LDN1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:27:12 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:36654 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2LDN1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:27:09 -0500
Date: Tue, 4 Dec 2012 08:27:01 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: boyu.mt@taobao.com, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: next: ext4 build failure
Message-ID: <20121204132701.GA29083@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jiri Slaby <jslaby@suse.cz>, boyu.mt@taobao.com,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <50BDC25C.5020509@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BDC25C.5020509@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 10:29:00AM +0100, Jiri Slaby wrote:
> Hi,
> 
> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
> Author: Tao Ma <boyu.mt@taobao.com>
> Date:   Sun Dec 2 20:30:52 2012 -0500
> 
>     ext4: let fallocate handle inline data correctly
> 
> added
> 
> static int int ext4_convert_inline_data(struct inode *inode)
> 
>        ^^^^^^^
> 
> when EXT4_FS_XATTR is unset.
> 
> Care to fix that?

Oops.  Thanks for catching this!!!

						- Ted

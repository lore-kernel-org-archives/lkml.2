Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020Ab1FACW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:22:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:36893 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161004Ab1FACW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:22:26 -0400
Date: Tue, 31 May 2011 19:28:15 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Sam Gandhi <samgandhi9@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can someone explain s_xattr field in the superblock?
Message-ID: <20110531232815.GA4837@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sam Gandhi <samgandhi9@gmail.com>, linux-kernel@vger.kernel.org
References: <BANLkTikuz1c9dCB65PqrHCXMSt+7_cS11w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikuz1c9dCB65PqrHCXMSt+7_cS11w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 08:52:41AM -0700, Sam Gandhi wrote:
> 
> I have seen some file systems like jffs2/ext4 etc setup the s_xattr
> field in the superblock structure.
> But there are files systems that  do not initialize s_xattr field in
> the superblock.
> 
> Can someone kindly explain what functionality  does s_xattr on super
> block provides? What kinds of things file system wouldn't be able to
> do if the superblock doesn't have this initialized?

It provides support for extended attributes, which is often
abbreviated as (not surpisingly) xattr.  Some file systems don't
support extended attributes, so they don't need to setup s_xattr.

For more information, read the attr(5) man page: "man 5 attr".

    	 	      	       	       	   - Ted

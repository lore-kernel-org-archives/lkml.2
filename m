Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab1BXVXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:23:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41446 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab1BXVXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:23:22 -0500
Date: Thu, 24 Feb 2011 21:23:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: encode_fh: have inode but no dentry
Message-ID: <20110224212317.GD22723@ZenIV.linux.org.uk>
References: <c4d12fe2-2175-4d59-9ef2-e6d5996023f0@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d12fe2-2175-4d59-9ef2-e6d5996023f0@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 01:16:34PM -0800, Dan Magenheimer wrote:
> Hi Aneesh --
> 
> I see you are continuing with encode_fh related
> development so I thought I would bring this up
> with you.
> 
> I have a need to call the encode_fh op in a
> situation where I have an inode but not a dentry,
> and calling d_find_alias(inode) sometimes returns
> NULL.  In my usage, connectable is always zero, so
> having just the inode should be sufficient to get
> useful results from encode_fh, at least for the
> filesystems I've looked at.

[snip]

> Such a change would require a patch that touched
> nearly every filesystem so it's clearly not to
> be taken lightly.
> 
> Any thoughts on this?

How about "tell us what do you need that for", for starters?

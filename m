Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2CYBQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 21:16:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43822 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2CYBQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 21:16:26 -0400
Date: Sat, 24 Mar 2012 21:16:13 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: No longer export ext2_fs.h to user space
Message-ID: <20120325011613.GB32554@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@ZenIV.linux.org.uk>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
References: <20120322183135.GC4028@thunk.org>
 <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de>
 <20120323131331.GA29631@thunk.org>
 <20120323175534.GI6589@ZenIV.linux.org.uk>
 <20120324215152.GA32554@thunk.org>
 <4F6E47C5.6040306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6E47C5.6040306@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 03:16:37PM -0700, H. Peter Anvin wrote:
> > Someone who was compiling "the latest version" of syslinux has
> > submitted a kernel bugzilla entry that this was breaking due to
> > ext2_fs.h using umode_t which was no longer being exported by the
> > kernel header files.  Given that ext2_fs.h is about to go ***poof***
> > (Al already has the changes in his vfs git tree), I thought I should
> > give you a heads up....
> > 
> 
> Thanks.  Syslinux already includes a private copy of ext2_fs.h, but I
> need to scrub the umode_t inclusion.

Ah, good.  I'll close the kernel bugzilla report in that case.

Thanks,

    	   	   	      	  	 - Ted


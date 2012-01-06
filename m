Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab2AFS6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:58:43 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:42347 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab2AFS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:58:40 -0500
Date: Fri, 6 Jan 2012 10:57:58 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Theodore Tso <tytso@mit.edu>, Sunil Mushran <sunil.mushran@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel Devel <linux-fsdevel@vger.kernel.org>,
        ext4 development <linux-ext4@vger.kernel.org>,
        Coly Li <colyli@gmail.com>
Subject: Re: [PATCH v2.2 00/23] ext4: Add metadata checksumming
Message-ID: <20120106185758.GO8233@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com> <20111214011028.GA8233@tux1.beaverton.ibm.com> <20111214013158.GB8233@tux1.beaverton.ibm.com> <816F9C6C-51E4-4CB2-84F7-762EC10CB282@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <816F9C6C-51E4-4CB2-84F7-762EC10CB282@dilger.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 12010618-7408-0000-0000-000001B6EDC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 11:46:17AM -0700, Andreas Dilger wrote:
> On Tue, Dec 13, 2011 at 04:46:14PM -0800, Darrick J. Wong wrote:
> > This patchset has been tested on 3.2.0-rc5 on x64, i386, ppc64, and ppc32.
> > The patches seems to work fine on all four platforms.
> [snip]
> > --D
> > 
> > [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> 
> This URL is broken due to the kernel.org rebuild, so if it is going into
> Git it should be updated to the new URL:
> 
> https://ext4.wiki.kernel.org/articles/e/x/t/Ext4_Metadata_Checksums_4d24.html

Ok, I was about to respam^post the patchset since the merge window is open
again.  I'll update the URL.

Anyone know if wiki logins/write access will be restored soon?

--D
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


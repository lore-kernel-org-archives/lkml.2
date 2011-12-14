Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1LNBcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:32:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43783 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab1LNBcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:32:05 -0500
Date: Tue, 13 Dec 2011 17:31:58 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH v2.2 00/23] ext4: Add metadata checksumming
Message-ID: <20111214013158.GB8233@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com> <20111214011028.GA8233@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214011028.GA8233@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11121401-1780-0000-0000-0000019BFEE7
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000240; HX=3.00000179; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00095891; UDB=6.00025040; UTC=2011-12-14
 01:32:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 05:10:28PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 13, 2011 at 04:46:14PM -0800, Darrick J. Wong wrote:
<snip>
> > This patchset has been tested on 3.2.0-rc5 on x64, i386, ppc64, and ppc32.  The
> > patches seems to work fine on all four platforms.
> 
> OH COME ON!!!!
> 
> stgit helpfully changed the From lines, screwing everything up.  Awesome.  I
> apologize, I wasn't expecting stgit to change the From: lines when I migrated
> the disk format changes to the front of the set.
> 
> I don't really want to respam the list just to fix this one little thing.  If
> people want more code changes I'll gladly make them and re-send.  If not, then
> Ted, I can just send you the whole mess as a big mbox file, or post them on a
> webserver somewhere, with correct attribution.

The e2fsprogs patchset is also found here:
http://djwong.org/docs/ext4_checksum_progs/

The kernel patchset is also found here:
http://djwong.org/docs/ext4_checksum_kernel/

(Honestly, I don't enjoy spamming the list with 91 patches.)

--D
> 
> --D
> > 
> > --D
> > 
> > [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


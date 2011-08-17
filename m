Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1HQRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:09:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57094 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1HQRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:09:53 -0400
Date: Wed, 17 Aug 2011 10:09:16 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mingming Cao <cmm@us.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>, Coly Li <colyli@gmail.com>
Subject: Re: [RFC] ext4 metadata checksumming design
Message-ID: <20110817170916.GQ20655@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110817032519.GN20655@tux1.beaverton.ibm.com> <20110817135719.GA25996@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817135719.GA25996@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 03:57:19PM +0200, Andi Kleen wrote:
> On Tue, Aug 16, 2011 at 08:25:19PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > I've created a page on the ext4 wiki outlining the patchset that I'm working on
> > to add metadata checksumming to ext4.  The page can be found at this address:
> > https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> 
> Can you summarize the differences to my earlier patchkit?

My new patchset intends to expand on your earlier inode/superblock patches by
adding checksums to nearly all metadata objects (directory blocks, htree,
extent tree, block/inode bitmaps, extended attributes).  It also adds code to
e2fsprogs to verify the checksums, and make the necessary adjustments to the
on-disk format to add space for checksums.

--D
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

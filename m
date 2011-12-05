Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1LETue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:50:34 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43904 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab1LETub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:50:31 -0500
Date: Mon, 5 Dec 2011 11:50:16 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 10/22] ext4: Verify and calculate checksums for extent
	tree blocks
Message-ID: <20111205195016.GE7137@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232725.19194.12626.stgit@elm3c44.beaverton.ibm.com> <20111205164015.GD32031@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205164015.GD32031@thunk.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11120519-5806-0000-0000-000010474599
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 11:40:15AM -0500, Ted Ts'o wrote:
> On Mon, Nov 28, 2011 at 03:27:25PM -0800, Darrick J. Wong wrote:
> >  /*
> > + * This is the extent tail on-disk structure.
> > + * All other extent structures are 12 bytes long.  It turns out that
> > + * block_size % 12 >= 4 for all valid block sizes (1k, 2k, 4k).
> 
> More generally, block_size % 12 is >= 4 for all powers of 2 greater
> than 12 bytes.  I'd probably remove (1k, 2k, 4k) because that might
> scare people who might say, "hey!  I'm using a 16k block size on my
> HPC system running on a Power or Itanium box --- am I going to be OK?".
> Valid block sizes go up to the page size of the hardware in question...

Ok.

--D


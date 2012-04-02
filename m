Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2DBWj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:39:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18677 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2DBWjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:39:24 -0400
Date: Mon, 2 Apr 2012 18:39:19 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402223350.GA16907@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F7A2A9B.000B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 06:33:50PM -0400, Dave Jones wrote:
> On Mon, Apr 02, 2012 at 06:28:02PM -0400, Chris Mason wrote:
>  
>  > > x86-64.
>  > > 
>  > > dmesg below.  (ignore the rpc oops, reported elsewhere, it's unrelated)
>  > 
>  > Well, there really are no btrfs messages in there at all.  Do you have
>  > free space for a clean copy of the btrfs partition?  Trying to figure
>  > out if you have a stale corruption (on two boxes seems really unlikely).
>  > I definitely can't reproduce it here.
> 
> Don't really have any free space for it (It's the / partition on both)
> 
> Is there a wip btrfs.fsck yet ? One of the machines is just a scratch testbox,
> so I'm happy to run it even if it'll potentially make things worse.

The current btrfsck repair mode will fix problems in the extent
allocation tree, but that probably isn't what you're seeing.  I'd just
run it read only and see if it finds any problems.

(You'll need the FS completely unmounted though).

-chris


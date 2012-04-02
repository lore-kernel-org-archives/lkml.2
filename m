Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2DBWd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:33:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab2DBWd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:33:56 -0400
Date: Mon, 2 Apr 2012 18:33:50 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120402223350.GA16907@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 06:28:02PM -0400, Chris Mason wrote:
 
 > > x86-64.
 > > 
 > > dmesg below.  (ignore the rpc oops, reported elsewhere, it's unrelated)
 > 
 > Well, there really are no btrfs messages in there at all.  Do you have
 > free space for a clean copy of the btrfs partition?  Trying to figure
 > out if you have a stale corruption (on two boxes seems really unlikely).
 > I definitely can't reproduce it here.

Don't really have any free space for it (It's the / partition on both)

Is there a wip btrfs.fsck yet ? One of the machines is just a scratch testbox,
so I'm happy to run it even if it'll potentially make things worse..

	Dave


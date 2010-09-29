Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0I2SC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:02:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab0I2SC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:02:27 -0400
Date: Wed, 29 Sep 2010 11:01:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] taskstats: Cleanup patches
Message-Id: <20100929110113.374e8651.akpm@linux-foundation.org>
In-Reply-To: <20100929075044.GF4261@balbir.in.ibm.com>
References: <20100928142058.796669370@linux.vnet.ibm.com>
	<20100928135117.4fdd5799.akpm@linux-foundation.org>
	<20100929075044.GF4261@balbir.in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 13:20:44 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [2010-09-28 13:51:17]:
> 
> > On Tue, 28 Sep 2010 16:20:58 +0200
> > Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> > 
> > > Hello Andrew,
> > > 
> > > It would be great, if you could accept the taskstats cleanup patches that
> > > are the prerequisite for the taskstats precise accounting patches. The
> > > patches do not add any new functionality. I think they make the code better
> > > readable and extensible:
> > > * 01/02: taskstats: Separate taskstats commands
> > > * 02/02: taskstats: Split fill_pid function
> > > 
> > 
> > Sure.
> > 
> > I've been sitting on a couple of taskstats patches for ages.  Mel's
> > delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
> > and Jeff's delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch.
> > 
> > I have notes against both of these indicating that Balbir had concerns
> > and as far as I know those concerns remain unresolved.  So I'll drop
> > those patches now - can you guys please reactivate them if you still
> > think we should be making these changes?
> > 
> 
> Hi, Andrew,
> 
> My concern with Jeff's patch was that it might break existing
> applications. He clarified it does not, I had requested for a version
> bump since the patches change some definitions
> 
> I had no concerns (IIRC) with Mel's patches. Mel wanted me to
> implement the "-c" option we had earlier.
> 

hm, OK, thanks, I requeued them for 2.6.37.

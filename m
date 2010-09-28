Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0I1Uwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:52:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab0I1Uwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:52:39 -0400
Date: Tue, 28 Sep 2010 13:51:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] taskstats: Cleanup patches
Message-Id: <20100928135117.4fdd5799.akpm@linux-foundation.org>
In-Reply-To: <20100928142058.796669370@linux.vnet.ibm.com>
References: <20100928142058.796669370@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 16:20:58 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> Hello Andrew,
> 
> It would be great, if you could accept the taskstats cleanup patches that
> are the prerequisite for the taskstats precise accounting patches. The
> patches do not add any new functionality. I think they make the code better
> readable and extensible:
> * 01/02: taskstats: Separate taskstats commands
> * 02/02: taskstats: Split fill_pid function
> 

Sure.

I've been sitting on a couple of taskstats patches for ages.  Mel's
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
and Jeff's delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch.

I have notes against both of these indicating that Balbir had concerns
and as far as I know those concerns remain unresolved.  So I'll drop
those patches now - can you guys please reactivate them if you still
think we should be making these changes?


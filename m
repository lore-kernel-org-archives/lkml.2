Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2FKTmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2FKTml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:42:41 -0400
Date: Mon, 11 Jun 2012 21:41:16 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Jones <drjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        xen-devel@lists.xensource.com, Petr Matousek <pmatouse@redhat.com>,
        676360@bugs.debian.org, Greg KH <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ulrich Obergfell <uobergfe@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Jan Beulich <jbeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Larry Woodman <lwoodman@redhat.com>, alan@lxorguk.ukuu.org.uk
Subject: Re: [Xen-devel] [PATCH] thp: avoid atomic64_read in pmd_read_atomic
 for 32bit PAE\
Message-ID: <20120611194113.GH3094@redhat.com>
References: <20120610020331.GA26100@localhost.localdomain>
 <4728e392-7130-4967-aa79-8da12f929191@zmail17.collab.prod.int.phx2.redhat.com>
 <20120611192738.GM14535@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611192738.GM14535@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 11, 2012 at 03:27:38PM -0400, Konrad Rzeszutek Wilk wrote:
> > > Nice. Andrew, any chane you could test this patch on the affected
> > > Xen hypervisors? Was it as easy to reproduce this on a RHEL5 (U1?)
> > > hypervisor or is it really only on Linode and Amazon EC2?
> > > 
> > 
> > Originally, I was able to reproduce the issue easily with a RHEL5
> > host. Now, with this patch it's fixed.
> 
> OK, so Tested-by: Andrew Jones..
> and from my perspective it looks good - so Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks for testing and reviews.

> Andrea, any chance you can respin this patch and send it to Linus for 3.5 please?

Andrew merged it in -mm last Friday, so I would expect it to go
upstream soon through the -mm flow (I assume everyone has been
rightfully waiting a bit of time for testing and reviews to be sure).

Andrea

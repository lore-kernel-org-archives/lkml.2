Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab2FKTgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:36:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27165 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2FKTgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:36:39 -0400
Date: Mon, 11 Jun 2012 15:27:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Jones <drjones@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Andrea Arcangeli <aarcange@redhat.com>, xen-devel@lists.xensource.com,
        Petr Matousek <pmatouse@redhat.com>, 676360@bugs.debian.org,
        Greg KH <gregkh@linuxfoundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Jan Beulich <jbeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Larry Woodman <lwoodman@redhat.com>, alan@lxorguk.ukuu.org.uk
Subject: Re: [Xen-devel] [PATCH] thp: avoid atomic64_read in pmd_read_atomic
 for 32bit PAE\
Message-ID: <20120611192738.GM14535@phenom.dumpdata.com>
References: <20120610020331.GA26100@localhost.localdomain>
 <4728e392-7130-4967-aa79-8da12f929191@zmail17.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4728e392-7130-4967-aa79-8da12f929191@zmail17.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Nice. Andrew, any chane you could test this patch on the affected
> > Xen hypervisors? Was it as easy to reproduce this on a RHEL5 (U1?)
> > hypervisor or is it really only on Linode and Amazon EC2?
> > 
> 
> Originally, I was able to reproduce the issue easily with a RHEL5
> host. Now, with this patch it's fixed.

OK, so Tested-by: Andrew Jones..
and from my perspective it looks good - so Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Andrea, any chance you can respin this patch and send it to Linus for 3.5 please?

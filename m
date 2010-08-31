Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0HaMx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:53:56 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:45139 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0HaMxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:53:54 -0400
Date: Tue, 31 Aug 2010 15:53:01 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: lkml@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux390@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@lst.de>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] wire up sys_time_change_notify() on s390
Message-ID: <20100831125301.GJ3003@shisha.kicks-ass.net>
Mail-Followup-To: Heiko Carstens <heiko.carstens@de.ibm.com>,
	lkml@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux390@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
	Jesper Nilsson <jesper.nilsson@axis.com>,
	David Howells <dhowells@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christoph Hellwig <hch@lst.de>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
 <1283255151-6364-7-git-send-email-virtuoso@slind.org>
 <20100831124928.GB2166@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831124928.GB2166@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 02:49:28 +0200, Heiko Carstens wrote:
> On Tue, Aug 31, 2010 at 02:45:51PM +0300, Alexander Shishkin wrote:
> > diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
> > index a8fee1b..b242383 100644
> > --- a/arch/s390/kernel/syscalls.S
> > +++ b/arch/s390/kernel/syscalls.S
> > @@ -343,3 +343,4 @@ SYSCALL(sys_perf_event_open,sys_perf_event_open,sys_perf_event_open_wrapper)
> >  SYSCALL(sys_fanotify_init,sys_fanotify_init,sys_fanotify_init_wrapper)
> >  SYSCALL(sys_fanotify_mark,sys_fanotify_mark,sys_fanotify_mark_wrapper)
> >  SYSCALL(sys_prlimit64,sys_prlimit64,sys_prlimit64_wrapper)
> > +SYSCALL(sys_time_change_notify,sys_time_change_notify,sys_time_change_notify_wrapper) /* 335 */
> > \ No newline at end of file
> 
> Please add the missing newline. Thanks.

Oops. Will do.

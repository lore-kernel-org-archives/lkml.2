Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2E3S0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:26:33 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60738 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272Ab2E3S03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:26:29 -0400
Date: Wed, 30 May 2012 23:53:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: simplify the usage of uprobe->pending_list
Message-ID: <20120530182307.GP15587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
 <20120530165846.GC8085@redhat.com>
 <20120530174858.GN15587@linux.vnet.ibm.com>
 <20120530181006.GA19471@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120530181006.GA19471@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053018-5806-0000-0000-000015B6023F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-05-30 20:10:06]:

> On 05/30, Srikar Dronamraju wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> [2012-05-30 18:58:46]:
> >
> > > uprobe->pending_list is only used to create the temporary list,
> > > it has no meaning after we drop uprobes_mmap_hash(inode).
> > >
> > > No need to initialize this node or remove it from tmp_list, and
> > > we can use list_for_each_entry().
> >
> >
> > I actually dont see the patch that removed the uprobe->pending_list.
> 
> I think you misread this cleanup. Or may be I misunderstood you...

Yes, I  misread the patch. Sorry for the noise. 
I will take a look again tomorrow.

-- 
Thanks and regards
Srikar


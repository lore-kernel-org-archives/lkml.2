Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2BIOtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:49:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2BIOtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:49:05 -0500
Date: Thu, 9 Feb 2012 09:48:57 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
Message-ID: <20120209144857.GC5650@redhat.com>
References: <1328206323-25580-1-git-send-email-dzickus@redhat.com>
 <m1r4ycsts1.fsf@fess.ebiederm.org>
 <20120207215741.GD5650@redhat.com>
 <20120207221924.GH6346@redhat.com>
 <m1r4y6i5cw.fsf@fess.ebiederm.org>
 <20120208201145.GX5650@redhat.com>
 <m1sjilc4vh.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sjilc4vh.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 02:55:14PM -0800, Eric W. Biederman wrote:
> > I ran lkdtm by panic'ing in the interrupt handle thus leaving device
> > interrupt un-ack'd and the apic might have been un-ack'd too (jprobes
> > hooked in at do_IRQ).  3 out 3 times the second kernel came up on my core2
> > quad.
> 
> That sounds like more than enough basic testing for me.  Document your
> testing in a patch description and let's get the unnecessary local apic
> and ioapic stomping removed from the kexec on panic path.
> 
> There were bugs.  We deleted the code that had them.  The bugs are gone
> and there are no new problems goes over very well in my book.

Great.  Thanks.  I'll put together the patch.

Cheers,
Don

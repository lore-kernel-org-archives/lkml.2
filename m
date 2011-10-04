Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1JDSR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:17:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab1JDSR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:17:56 -0400
Date: Tue, 4 Oct 2011 20:13:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matt Fleming <matt@console-pimps.org>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111004181357.GA6822@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com> <20110930235625.GD2658@mtj.dyndns.org> <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com> <1317474209.12973.15.camel@twins> <20111003130701.GB25952@redhat.com> <1317655320.20367.25.camel@twins> <20111004171437.GA3489@redhat.com> <CA+55aFza+fvdC4UY+JAQ61zip3t3Zxm2zUPAzv3Oqux2L66cDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFza+fvdC4UY+JAQ61zip3t3Zxm2zUPAzv3Oqux2L66cDQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Linus Torvalds wrote:
>
> On Tue, Oct 4, 2011 at 10:14 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Whatever we do with the locking, this can't remove O(nr_threads),
> > although read_lock() could help to reduce the contention.
>
> Read locks often make things worse.

Yes, yes, I see, thanks.

I meant that probably "more concurrency" was the reason for rwlock
this series adds.

Oleg.


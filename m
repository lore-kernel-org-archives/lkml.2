Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3AIRqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:46:10 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36852 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab3AIRqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:46:07 -0500
Date: Wed, 9 Jan 2013 23:14:49 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Move alloc_page() from xol_add_vma() to
 xol_alloc_area()
Message-ID: <20130109174449.GM1325@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121231175150.GA32066@redhat.com>
 <20121231175212.GA32088@redhat.com>
 <20130108114607.GD1325@linux.vnet.ibm.com>
 <20130108175822.GA1048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130108175822.GA1048@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010917-5112-0000-0000-000011520EAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-08 18:58:22]:

> On 01/08, Srikar Dronamraju wrote:
> >
> > (One simple check below)
> >
> > Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Thanks,
> 
> > > @@ -1072,11 +1064,8 @@ static int xol_add_vma(struct xol_area *area)
> > >  	smp_wmb();	/* pairs with get_xol_area() */
> > >  	mm->uprobes_state.xol_area = area;
> > >  	ret = 0;
> > > -
> > > -fail:
> > > + fail:
> >
> > Not sure if the space before label is intentional?
> > Its true of other labels below also.
> 
> Yes, this was intentional although almost subconscious.
> 
> Personally I prefer to add a space before the label, this helps
> /usr/bin/diff to not confuse this label with the function name.
> 
> But I can stop this if you dislike.

I dont have any preference. Just wanted to check if it was intentional
or accidental. I thought checkpatch.pl cribs for this.
I think somebody while reviewing my patches had pointed out the same to me.
I cant remember who and probably my format wasnt just a single space
before label.

> 
> Oleg.
> 


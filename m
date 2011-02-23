Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1BWTkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:40:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1BWTkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:40:10 -0500
Date: Wed, 23 Feb 2011 20:31:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110223193117.GA3231@redhat.com>
References: <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com> <20110214200130.GA21559@redhat.com> <20110215152448.GL3160@htj.dyndns.org> <20110215173149.239601807B7@magilla.sf.frob.com> <20110215202747.GA20560@redhat.com> <20110218170212.GS21209@htj.dyndns.org> <20110218193709.GA9700@redhat.com> <20110221162206.GN31267@htj.dyndns.org> <20110221164908.GA25803@redhat.com> <20110221165908.GO31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221165908.GO31267@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Tejun Heo wrote:
>
> Hey,
>
> On Mon, Feb 21, 2011 at 05:49:08PM +0100, Oleg Nesterov wrote:
> > > BTW, I plan on separating out all ptrace related stuff into a separate
> > > struct as it's not used by most tasks anyway, so I don't think we need
> > > to be too concerned about several more fields.
> >
> > This is funny.
> >
> > I already did this change (it even had some review on lkml). And it was
> > discussed again (on archer@sourceware.org) a couple of days ago. Yes,
> > probably we should finally do this. Unfortunately, this complicates the
> > attach-to-all-threads request (new feature), but anyway.
>
> Heh, well, I also have a mostly working patch but hey if you already
> did it, all the better.  :-)

Argh, sorry. If you already have the patch - please send it.

Otherwise I'll try to refresh the old series, but not before the next week.


And. As usual, sorry for the delay, I'll try to reply to other emails
tomorrow.

Oleg.


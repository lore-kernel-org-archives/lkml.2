Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0KZKlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:41:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43907 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0KZKlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:41:17 -0500
Date: Fri, 26 Nov 2010 11:40:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>, Glauber Costa <glommer@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Olivier Hanesse <olivier.hanesse@gmail.com>,
        Avi Kivity <avi@redhat.com>, Eelco Dolstra <e.dolstra@tudelft.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/pvclock-xen: zero last_value on resume
Message-ID: <20101126104047.GA9798@elte.hu>
References: <4CC708DE.1070000@goop.org>
 <4CEACFAB.90503@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEACFAB.90503@goop.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 10/26/2010 09:59 AM, Jeremy Fitzhardinge wrote:
> >
> > If the guest domain has been suspend/resumed or migrated, then the
> > system clock backing the pvclock clocksource may revert to a smaller
> > value (ie, can be non-monotonic across the migration/save-restore).
> > Make sure we zero last_value in that case so that the domain
> > continues to see clock updates.
> 
> Ping?  Looks like this fell through the gaps.

Does not apply cleanly here - mind resending the latest version?

Thanks,

	Ingo

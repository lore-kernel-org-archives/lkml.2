Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013Ab1EAQqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:46:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab1EAQqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:46:51 -0400
Date: Sun, 1 May 2011 18:46:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] x2apic optimization, round 4
Message-ID: <20110501164635.GA21833@elte.hu>
References: <20110430171459.685415696@openvz.org>
 <4DBC6DC1.30900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBC6DC1.30900@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 04/30/2011 08:14 PM, Cyrill Gorcunov wrote:
> >   Hi Ingo, here is an updated series of two patches for
> >x2apic cluster mode ipi optimization. Please take a
> >look.
> >
> >   The only concern which was unresolved is a messy bit
> >in default_setup_apic_routing(), so we've added a FIXME
> >there and clean it up as only time permits. Actually I
> >have a plan to merge probe_32/64.c into single file (and
> >even started working on this task) but not yes succeed.
> >
> >   Anyway I think patches should be in a good shape now and
> >probably we could merge them to not lose?
> >
> >   Comments are welcome.
> 
> Very nice!  This will also significantly speed up kvm guests using x2apic.

Ok. It would be nice to know on what systems these patches were tested, i.e. i 
suppose x2apic-enabled ones?

Thanks,

	Ingo

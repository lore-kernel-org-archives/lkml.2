Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1EBFjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1EBFjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:39:48 -0400
Date: Mon, 2 May 2011 08:39:28 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] x2apic optimization, round 4
Message-ID: <20110502053928.GB18376@redhat.com>
References: <20110430171459.685415696@openvz.org>
 <4DBC6DC1.30900@redhat.com>
 <20110501164635.GA21833@elte.hu>
 <BANLkTimpk3Ye=HvCohTbKT7Jzedo_V07Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BANLkTimpk3Ye=HvCohTbKT7Jzedo_V07Yg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 09:11:35PM +0400, Cyrill Gorcunov wrote:
> On Sun, May 1, 2011 at 8:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Avi Kivity <avi@redhat.com> wrote:
> >
> >> On 04/30/2011 08:14 PM, Cyrill Gorcunov wrote:
> >> > š Hi Ingo, here is an updated series of two patches for
> >> >x2apic cluster mode ipi optimization. Please take a
> >> >look.
> >> >
> >> > š The only concern which was unresolved is a messy bit
> >> >in default_setup_apic_routing(), so we've added a FIXME
> >> >there and clean it up as only time permits. Actually I
> >> >have a plan to merge probe_32/64.c into single file (and
> >> >even started working on this task) but not yes succeed.
> >> >
> >> > š Anyway I think patches should be in a good shape now and
> >> >probably we could merge them to not lose?
> >> >
> >> > š Comments are welcome.
> >>
> >> Very nice! šThis will also significantly speed up kvm guests using x2apic.
> >
> > Ok. It would be nice to know on what systems these patches were tested, i.e. i
> > suppose x2apic-enabled ones?
> >
> > Thanks,
> >
> > š š š šIngo
> >
> 
> Suresh has tested them on Westmere-Ex system, I personally don't have
> such machine.
Can you test in in KVM with x2apic emulation enabled?

--
			Gleb.

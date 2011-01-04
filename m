Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1ADJYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:24:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1ADJYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:24:45 -0500
Date: Tue, 4 Jan 2011 10:24:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to
 hypervisor.h
Message-ID: <20110104092418.GA31281@elte.hu>
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
 <4D10E0C2.3020000@goop.org>
 <4D10EED0.2030507@redhat.com>
 <201101041657.36123.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101041657.36123.sheng@linux.intel.com>
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


* Sheng Yang <sheng@linux.intel.com> wrote:

> On Wednesday 22 December 2010 02:15:44 Avi Kivity wrote:
> > On 12/21/2010 07:15 PM, Jeremy Fitzhardinge wrote:
> > > On 12/20/2010 10:18 PM, Sheng Yang wrote:
> > > >  Then we can reuse it for Xen later.
> > > 
> > > You should probably get someone kvm-ish to ack this too.
> > 
> > Looks good to me.
> 
> Ingo,
> 
> Comments?

Acked-by: Ingo Molnar <mingo@elte.hu>

I suspect these patches want to be carried in the Xen tree, right? Shouldnt cause 
too bad conflicts, as long as the Xen tree is pushed after the x86 tree in the merge 
window.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1AEPrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:47:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60108 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1AEPq7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 5 Jan 2011 10:46:59 -0500
Date: Wed, 5 Jan 2011 10:46:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to
 hypervisor.h
Message-ID: <20110105154632.GB7913@dumpdata.com>
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
 <201101041657.36123.sheng@linux.intel.com>
 <20110104092418.GA31281@elte.hu>
 <201101050952.00104.sheng@linux.intel.com>
 <4D242070.3070602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D242070.3070602@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 06:40:32PM +1100, Jeremy Fitzhardinge wrote:
> On 01/05/2011 12:51 PM, Sheng Yang wrote:
> > On Tuesday 04 January 2011 17:24:18 Ingo Molnar wrote:
> >> * Sheng Yang <sheng@linux.intel.com> wrote:
> >>> On Wednesday 22 December 2010 02:15:44 Avi Kivity wrote:
> >>>> On 12/21/2010 07:15 PM, Jeremy Fitzhardinge wrote:
> >>>>> On 12/20/2010 10:18 PM, Sheng Yang wrote:
> >>>>>>  Then we can reuse it for Xen later.
> >>>>> You should probably get someone kvm-ish to ack this too.
> >>>> Looks good to me.
> >>> Ingo,
> >>>
> >>> Comments?
> >> Acked-by: Ingo Molnar <mingo@elte.hu>
> >>
> >> I suspect these patches want to be carried in the Xen tree, right? Shouldnt
> >> cause too bad conflicts, as long as the Xen tree is pushed after the x86
> >> tree in the merge window.
> > Jeremy?
> 
> Sure, I'm OK with that, but I'm on vacation until the 15th.  Konrad, can
> you pick this up?

Done.
> 
> Thanks,
>     J

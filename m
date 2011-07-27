Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1G0UNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:13:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33461 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1G0UNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:13:49 -0400
Date: Wed, 27 Jul 2011 22:13:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        "ostr@amd64.org" <ostr@amd64.org>, "jvpeetz@web.de" <jvpeetz@web.de>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] [25/98] x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
Message-ID: <20110727201348.GB8006@one.firstfloor.org>
References: <20110726534.972201586@firstfloor.org> <20110727003517.6946C2403FF@tassilo.jf.intel.com> <4E3006DF.6010906@amd.com> <20110727154203.GB16180@tassilo.jf.intel.com> <4E303785.8000102@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E303785.8000102@amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:06:29PM -0400, Boris Ostrovsky wrote:
> On 07/27/11 11:42, Andi Kleen wrote:
> >>Andi, this patch is unnecessary.
> >>
> >>It (as well as 328935e6348c6a7cb34798a68c326f4b8372e68a and
> >>14fb57dccb6e1defe9f89a66f548fcb24c374c1d) is superseded by
> >>e9cdd343a5e42c43bcda01e609fa23089e026470 upstream
> >
> >Is it obsolete in 2.6.35 too?
> 
> Yes.
> 
> >
> >So what should I do? Drop this one and merge some other?
> >Or just drop?
> 
> Please drop it (and skip the other two that I mentioned above) and apply 
> e9cdd343a5e42c43bcda01e609fa23089e026470.

Looks like I already had a revert and that one too. I dropped the 
patch+revert

-Andi

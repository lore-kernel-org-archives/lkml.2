Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2FDEsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:48:43 -0400
Received: from ozlabs.org ([203.10.76.45]:52360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab2FDEsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:48:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alex Shi <alex.shi@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
In-Reply-To: <4FC7289D.2080009@intel.com>
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com> <4FC373D9.7040109@linux.vnet.ibm.com> <4FC38277.2030500@intel.com> <4FC39904.9080309@linux.vnet.ibm.com> <4FC4236F.309@intel.com> <4FC5F90C.9070308@intel.com> <CAHGf_=p=6t7Heyuio2t1q6Qb8KWCfnWzFjuR3kCO0VRTjiUBdA@mail.gmail.com> <4FC7289D.2080009@intel.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jun 2012 11:07:47 +0930
Message-ID: <87aa0j3lhw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012 16:15:25 +0800, Alex Shi <alex.shi@intel.com> wrote:
> On 05/30/2012 06:49 PM, KOSAKI Motohiro wrote:
> 
> > On Wed, May 30, 2012 at 6:40 AM, Alex Shi <alex.shi@intel.com> wrote:
> >> On 05/29/2012 09:16 AM, Alex Shi wrote:
> >>
> >>>
> >>>>>> s/return/Returns
> >>>>>>
> >>>>>> What do you mean by "old" cpumask?
> >>>>>
> >>>>> Thanks for comments!
> >>>>> Should be "the old bitmap of cpumask"?
> >>>>>
> >>>>
> >>>>
> >>>> No, there is no "old" or "new" cpumask here because this function doesn't
> >>>> change the cpumask. It just checks if that bit is set.
> >>>> So something like:
> >>>> Returns 1 if 'cpu' is set in 'cpumask', else returns 0.
> >>>>
> >>>
> >>>
> >>>
> >>> Sure, thanks! and comments changed again following your style.
> >>> Is the following new update patch ok?
> >>
> >>
> >> Any further comments for this patch? :)
> > 
> > Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> 
> Thanks!
> Does someone like to pick up this patch? :)

Applied, thanks!

Cheers,
Rusty.

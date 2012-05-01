Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2EAUXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:23:48 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:31308 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752100Ab2EAUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:23:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .QAG3o8VM1kWCJHgauDq0Gc7VKmW2Lp_9dF9SmEZecpQTLy
 4MzRNWv4hh6vZ7uVFsgWAK12px9GgnzulU0WzOLikqjAtbb3jXt5riBvXy0g
 vH3B2LwAvmdvp1TQP5Io0tpsTpWYrDzSUXsAMsFv3P79wGKTdGgeEnt3Z.tg
 EGX926u1p8T0TRah_BOwDxLtbEEqFWLgYNeSFNDFph8Jbq1mqCvReYxnV5Eh
 SPpK7W.C3OvCLu0ycds0pOeAT9iusJRYyeVk9DvEcWFteQl6HhuU3bfAHeOk
 oYp_NT5kYa_RnO__kNYwZ2qjMjCn5oNPEfBhTGqCxq7g67HIX2mWnuMJwl5w
 yM2.HSTSLvTlv6BtDdePtjf6XIzEEv3en5lWuBDPt76TZ6Qv9IsBRCb0ILwI
 B5ee1YXgdi8ZfUWzlj_SYTGXxcoqKsS0YVBQa
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 1 May 2012 15:23:43 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Waiman Long <waiman.long@hp.com>, "mpm@selenic.com" <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Morris, Donald George \(HP-UX Cupertino\)" <don.morris@hp.com>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] slub: prevent validate_slab() error due to race
 condition
In-Reply-To: <CAOJsxLGXZsq22LuNa5ef5iv7Jy0A0w_S2MbDQeBW=dFvUwFRjA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205011522340.2091@router.home>
References: <1335466658-29063-1-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.00.1204270911080.29198@router.home> <4F9AFD28.2030801@hp.com> <CAOJsxLGXZsq22LuNa5ef5iv7Jy0A0w_S2MbDQeBW=dFvUwFRjA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Pekka Enberg wrote:

> On Fri, Apr 27, 2012 at 11:10 PM, Waiman Long <waiman.long@hp.com> wrote:
> > Thank for the quick response. I have no problem for moving the node-lock
> > taking into free_debug_processing. Of the 2 problems that are reported, this
> > is a more serious one and so need to be fixed sooner rather than later. For
> > the other one, we can take more time to find a better solution.
> >
> > So are you going to integrate your change to the mainline?
>
> Christoph, can you send the patch with an improved changelog that also
> explains what the problem is?


Will do so once I get back from the conference I am at.

> How far back in the stable series do we want to backport this?

This only affects slab validation when running with deubgging so I would
suggest to merge in the next cycle.


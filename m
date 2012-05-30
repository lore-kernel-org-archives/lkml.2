Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2E3Pko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:40:44 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:31221 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753620Ab2E3Pkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:40:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rp9BKzUVM1mDlB3LCrc2jnjrDLxo2mvP93sH.J3tBWhNuw7
 zKWcObw2mX5CatxyyPziIuTqDNtJEz3E6spyBWqcasxcY2UUJUcAWVGrnGr2
 VbnMjPvX6wEU0Vt0MEuRo93ouvdEElsIxQttrbOFuTtXhqk6jIklHXOMRgxD
 uyV1z21E1JO7K7tPcHmKoIviO0zdFm1OEzteTTmMpAGHJjnBr7AKvzM92i9p
 rPFpxJRFC2iNFbSWsNAlYrok_Kuqk5C8d5_Mb7mFnHR_MJD7O4gUuH1DYqyj
 loYpeO3rBCKEwV.fl74DUUoNa1a7SwWiJDhAsEAt5dhmiCYzFscGlEWOviBt
 nkFM89knAryq65c028F6O33CvVOWdGX4zmWLQ3X8JZL6VkCvD27Y3JCY_vHk
 e
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 30 May 2012 10:40:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <alpine.LFD.2.02.1205300947180.2681@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1205301040170.29257@router.home>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org> <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com> <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com> <alpine.LFD.2.02.1205300947180.2681@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Pekka Enberg wrote:

> On Tue, 8 May 2012, David Rientjes wrote:
> > > But this doesn't mean NAK anyway.
> > >
> > >  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >
> > Sigh, this was acked by Christoph and KOSAKI when the logic is reversed
> > and does the exact opposite of what's intended?
>
> Ping? Anyone going to send a fixed up patch?

I thought this was done and fixed in another email thread?


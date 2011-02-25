Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1BYQn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:43:57 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:22565 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932265Ab1BYQn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:43:56 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: u8Sw6ugVM1lQAF.AqADaAEEeDjzMIHrYOilio6EpGsleje0
 Ix.X2gn5oN6KfhfMoPYfDgKb38GHOqX7zJVoPWKzgbjqZ2AxSdEq0CjR3yxk
 zxh3AC9IN5f8svOgLiNCdWyWzGuluRta057G.T9o8PH2_3PoUk7iAzCXJDDy
 kQ9qcD.QzQgF3KkxuE0OLw46OA.x4vHk16l14ReM0WjMO7npr43cdmxQ_ZiM
 A05eCUjjiyHg-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 25 Feb 2011 10:43:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110225163740.GS24828@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1102251041160.4996@router.home>
References: <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com> <20110121171914.GJ2832@htj.dyndns.org>
 <4D3D15AF.30508@zytor.com> <4D67AA06.5090200@cs.helsinki.fi> <20110225131949.GJ24828@htj.dyndns.org> <alpine.DEB.2.00.1102251025250.4996@router.home> <20110225163740.GS24828@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Tejun Heo wrote:

> On Fri, Feb 25, 2011 at 10:26:43AM -0600, Christoph Lameter wrote:
> > On Fri, 25 Feb 2011, Tejun Heo wrote:
> >
> > > > Ping? The current situation is that we're unable to merge a
> > > > perfectly good SLUB performance optimization because we can't seem
> > > > to agree on the this_cpu_cmpxchg_double() API.
> > >
> > > I thought cl was preparing new version of the patchset.  Christoph?
> >
> > In order to do that I would have to see a way to improve the
> > patches. None of the suggestions so far seem to be realizable.
>
> I see.  For some reason, I thought you and hpa agreed on something and
> you were writing up the patches.  I'll read the thread again.  Let's
> just pick one.  It's not like this is an API which will be used
> througout the tree.

We were discussing some hypothetical changes but as far as I can see all
those scenarios lead to more issues.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab1BYQ0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:26:48 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:35464 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755147Ab1BYQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:26:47 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ghBNzbEVM1mUfVVlnrFYOrUKJGK8IpgKQPmgeyCZhdISs4d
 19YLNvQxN2utmi7TYzPIcxUqRGYc40TKrnx95D2X177fB.ZE4xeR2uuF8EJZ
 yjnalvV9Se3rGwx.UtfX6lU8qbratuLVb0BE1Ap7sXohYcK.gYl3BpED_lck
 FhlGzTXs5hH1KpDe326hDOD4me9yh0jl4X6KrePfdumQbYwuJcMc_ZxkJtXC
 NcqbTtQ_SnRab8fgnMgnWhionJa1TZYErvfektuJEockzrsqPKd88JlPb_wn
 rhRfiAaTn.VB9PjKrKzouUlHOte.hzCIjylSszX5.0r_DcXU-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 25 Feb 2011 10:26:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110225131949.GJ24828@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1102251025250.4996@router.home>
References: <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
 <20110121171914.GJ2832@htj.dyndns.org> <4D3D15AF.30508@zytor.com> <4D67AA06.5090200@cs.helsinki.fi> <20110225131949.GJ24828@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Tejun Heo wrote:

> > Ping? The current situation is that we're unable to merge a
> > perfectly good SLUB performance optimization because we can't seem
> > to agree on the this_cpu_cmpxchg_double() API.
>
> I thought cl was preparing new version of the patchset.  Christoph?

In order to do that I would have to see a way to improve the
patches. None of the suggestions so far seem to be realizable.



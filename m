Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1AUR5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:57:17 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:33231 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754593Ab1AUR5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:57:13 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .ZD6WMAVM1nagv_8OJ_0Nd_92bwRHs3ULZBAkQnfL2QSss2
 1qQttNy05aC1UknwdZJG84j.7l3H7z7L38FSWrFspNngmTmAvHGIroYjEsDH
 POf_JO0NiiBeLn7s01OIW5MdM6h7wLSBF0kyefk31LJv46Yzoan_mDbS2fUE
 kDPbhUryrLD6z1S6mK9AGJi_r5ZiM1uknSgrrPBnJIcqHXa5d8Yd1IHrd_6M
 BNHsndIxuXWvqXIEph0oifGdGKRfK8UYqdtPgSlN04lk2TVb13KfIJTjLOy6
 NpQ0hDT7m6a_CETQSIxqcx9MERO1RK8hlXXFx7xmofifQb84-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 11:57:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
In-Reply-To: <20110121174817.GM2832@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1101211155150.15692@router.home>
References: <alpine.DEB.2.00.1012151404070.21102@router.home> <20110121171133.GI2832@htj.dyndns.org> <alpine.DEB.2.00.1101211114530.15692@router.home> <20110121172836.GK2832@htj.dyndns.org> <alpine.DEB.2.00.1101211139330.15692@router.home>
 <20110121174817.GM2832@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Tejun Heo wrote:

> On Fri, Jan 21, 2011 at 11:46:04AM -0600, Christoph Lameter wrote:
> > > Oh, you're right.  Sorry about that.  Can you please then add a
> > > comment noting that the operation is x86 only?  Maybe prefix it with
> > > x86_?
> >
> > For a function defined in an specific include file and only used in arch
> > specific code?
>
> Hmm?  asm/percpu.h gets included by linux/percpu.h, so it would end up
> in most .c files.

The function is defined in arch/x86/include/asm/percpu.h. At least my
patches here are that way.

#include "asm/percpu.h" will get you include/asm-generic/percpu.h on
other arches.



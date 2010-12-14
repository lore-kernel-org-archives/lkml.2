Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab0LNRf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:35:28 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:37069 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751891Ab0LNRf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:35:27 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _xT09.kVM1lUt_I13rUDQsFe0OJD5qIVZdDoW1bKtzHZO2d
 0gESeSyPwvTX.1G_JXtA5J.AizEVXh6mpk0KM3WxmM8cJEFpIs5sXZTbomP8
 OKq1IzQzozUw5dI2J58KGyG8z863U2.ucRiuTRLorbh54vbX8fj31v76MwmJ
 1_QW7H1STJAFDrONFI2vsA8CRpXaoqS9EwuBUZgXqjsIN9sjNu5TbJrEJLxv
 m.Viyx3ftRINOyZ_G1lKd919Laxf7ELRxu2d09mc7GF2M_1aNgdbqFO2Cpkp
 w_rnAXJ3OV2wbEjan3bTM4dDgTJZ2EmzEKn5tSo.a9bbuK64-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Dec 2010 11:35:21 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
In-Reply-To: <4D07A95C.7030703@kernel.org>
Message-ID: <alpine.DEB.2.00.1012141133550.17229@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home>
 <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, Tejun Heo wrote:

> > Great, that answers that!  I'll pick up the patch hopefully today (I'm
> > finally ramping back up on arch/x86 again after having been diverted to
> > an internal project for a while...)
>
> How do you want to route these?  All patches before this series is
> already in the percpu tree.  I can pull the generic bits and leave out
> the x86 bits so that x86 tree can pull in percpu bits and then put x86
> stuff on top of it.  If you wanna go that way, I would drop all x86
> related patches from the previous patchsets too.

I think it is better to merge the generic pieces and x86 at the same time.
Since this has worked so well with the percpu tree so far I'd say we
continue that way.

Regardless of how this will be merged: It would be good if hpa would take
a look at the patches we have accumulated so far.


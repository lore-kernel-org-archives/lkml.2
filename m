Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1ISUCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:02:41 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:37650 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753890Ab1ISUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:02:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Hk7MojMVM1lZX0hr0FVfGOTuZ9K3CgAQFeIH.2dSghaxLcv
 qdb_8kVhXWXsEaktoLRFcRsOoYmESfXv_obtuoo7LE6A4KSLFE1JyOv7dSjU
 ya5TEBQDo2Ii1VgY_zlZdsAebTXwU5VY5LWijPdKSnVOMg7mjue_It_j32W1
 oVHiZTy5JRzIZnJx.2eVXJuefNqd7v8cAf.8Lnx1PVhlhVqp.lL2JSl3Md7a
 jjJ0GZh7vFMjtTePDe.yw1QEXW7spE_QBlPOgdURJjjPd0V0aBSqrbHzCHzX
 xru9j8cjG9y_bdJRVbAqtxIJAVtjYzfqUdRLW_CNRAZaVmQKj7BhZ0fkGv82
 BwOOpGbCi6lp9KDq.GKM9qHaPSHbQ9d1_nZYZnlgmqKJHGDfkJyI4WJHNXd1
 L5_RTxpJm8MT9O6sL6Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Sep 2011 15:02:34 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Valdis.Kletnieks@vt.edu
cc: Vasiliy Kulikov <segoon@openwall.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
In-Reply-To: <14587.1316462369@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.2.00.1109191502040.13103@router.home>
References: <20110910164134.GA2442@albatros> <20110914192744.GC4529@outflux.net> <20110918170512.GA2351@albatros> <CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com> <20110919144657.GA5928@albatros> <CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
 <20110919155718.GB16272@albatros> <CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com> <20110919161837.GA2232@albatros> <CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com> <20110919173539.GA3751@albatros>           
 <alpine.DEB.2.00.1109191249450.10968@router.home> <14587.1316462369@turing-police.cc.vt.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Valdis.Kletnieks@vt.edu wrote:

> On Mon, 19 Sep 2011 12:51:10 CDT, Christoph Lameter said:
>
> > IMHO a restriction of access to slab statistics is reasonable in a
> > hardened environment. Make it dependent on CONFIG_SECURITY or some such
> > thing?
>
> Probably need to invent a separate Kconfig variable - CONFIG_SECURITY
> is probably a way-too-big hammer for this nail. I can see lots of systems
> that want to enable that, but won't want to tighten access to slab.

There is already CONFIG_SECURITY_DMESG_RESTRICT. Generalize that setting
to include all sorts of other kernel statistics?


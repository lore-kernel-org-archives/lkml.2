Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab1CTICx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 04:02:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51143 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab1CTICq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 04:02:46 -0400
Date: Sun, 20 Mar 2011 09:01:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Pekka Enberg <penberg@kernel.org>
Cc: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
In-Reply-To: <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net> <1300419170.16880.956.camel@gandalf.stny.rr.com>
 <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
 <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-541091532-1300608081=:28495"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-541091532-1300608081=:28495
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 20 Mar 2011, Pekka Enberg wrote:

> Hi,
> 
> On Fri, Mar 18, 2011 at 11:32 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> But if we can teach checkpatch to read the rule files, then maybe that
> >> would be beneficial.
> 
> On Sun, Mar 20, 2011 at 5:40 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > The problem is Perl doesn't really understand C, while Coccinelle does.
> 
> It would be nice if Coccinelle would be even more easy to setup and
> use during development. Like with Dave, Coccinelle has been on my todo
> list forever.

You have to get and set up Coccinelle on your own.  However, it is part of 
many Linux distributions, including ubuntu.

Afterwards, you can run make coccicheck to apply the semantic patches that 
are included in the kernel to the entire kernel.  There are some options 
to eg restrict the choice of rule, the choice of considered Linux files, 
and the format of the output.  Where possible we have taken 
decisions that are common with what is done elsewhere in the make file.

Documentation is in Documentation/coccinelle.txt

Suggestions for how to make it easier to use or the documentation more 
understandable are welcome.

thanks,
julia
---511516320-541091532-1300608081=:28495--

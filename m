Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0KCQH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:07:56 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39348 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab0KCQHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:07:55 -0400
Date: Wed, 3 Nov 2010 17:07:41 +0100
From: Florian Mickler <florian@mickler.org>
To: Audun Hoem <audun.hoem@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch.pl: fix CAST detection to not screw with
 parens handling
Message-ID: <20101103170741.66121ce1@schatten.dmk.lab>
In-Reply-To: <AANLkTim=L_J4BF9Zxkzqme-Rj77-MTiT0mGR5hp+t0xW@mail.gmail.com>
References: <AANLkTimA1d88FwGGE-BW4WvyuaFB7xewN_ubko+kj2+X@mail.gmail.com>
	<1288785873-16519-1-git-send-email-florian@mickler.org>
	<20101103162042.297958c3@schatten.dmk.lab>
	<AANLkTim=L_J4BF9Zxkzqme-Rj77-MTiT0mGR5hp+t0xW@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010 16:26:44 +0100
Audun Hoem <audun.hoem@gmail.com> wrote:

> On 11/3/10, Florian Mickler <florian@mickler.org> wrote:
> > On Wed,  3 Nov 2010 13:04:33 +0100
> > Florian Mickler <florian@mickler.org> wrote:
> >
> >> Casts have to be handled after the last type that is followed by an
> >> opening parenthesis is handled.
> >
> > That is the wrong fix. I realized now that with that patch we would
> > not claim anything as a CAST anymore. Better is probably to only claim
> > a CAST if av_pending is not set. Andy, would that work? It seems to be
> > alright... Do you have some tests for checkpatch?
> >
> > Testing it with the reported line and some other random samples it
> > seems to be alright.
> >
> 
> Probably good enough of a test to try it on random kernel code.

Yes, on random inspection of kernel code the new output looks good. 
(I've set dbg_values to 2 and diffed the output for some files of
the patched version with the output of the broken version)

I speculated on Andy to have a special set of problematic test
cases, but I looked through the git-log of checkpatch and tested some of
the stuff there. It all seems ok. 

Regards,
Flo

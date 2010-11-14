Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0KNU1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:27:40 -0500
Received: from smtp-out-139.synserver.de ([212.40.180.139]:1055 "EHLO
	smtp-out-139.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab0KNU1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:27:39 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 27557
Date: Sun, 14 Nov 2010 21:27:34 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101114202734.GA1627@arch.trippelsdorf.de>
References: <1289489200.11397.21.camel@maggy.simson.net>
 <20101111202703.GA16282@redhat.com>
 <1289514000.21413.204.camel@maggy.simson.net>
 <20101112181240.GB8659@redhat.com>
 <1289648524.22764.149.camel@maggy.simson.net>
 <1289755150.3228.44.camel@maggy.simson.net>
 <20101114174921.GA1569@arch.trippelsdorf.de>
 <1289758238.17491.12.camel@maggy.simson.net>
 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.14 at 12:20 -0800, Linus Torvalds wrote:
> On Sun, Nov 14, 2010 at 11:28 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > This catless version looks very good to me
> 
> Oh, btw, maybe one comment: is CONFIG_SCHED_AUTOGROUP_DEBUG even worth
> having as a config option? The only thing it enables is the small
> /proc interface, and I don't see any downside to just always having
> that if you have AUTOGROUP enabled in the first place.
> 
> It isn't like it's some traditional kernel debug feature that makes
> things slower or adds tons of debug output.

It also enables the sched_autogroup_handler, that you disliked seeing in
the previous version.
-- 
Markus

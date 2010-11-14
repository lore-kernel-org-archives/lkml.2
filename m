Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0KNT3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 14:29:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab0KNT3H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 14:29:07 -0500
MIME-Version: 1.0
In-Reply-To: <1289758238.17491.12.camel@maggy.simson.net>
References: <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net> <20101111202703.GA16282@redhat.com>
 <1289514000.21413.204.camel@maggy.simson.net> <20101112181240.GB8659@redhat.com>
 <1289648524.22764.149.camel@maggy.simson.net> <1289755150.3228.44.camel@maggy.simson.net>
 <20101114174921.GA1569@arch.trippelsdorf.de> <1289758238.17491.12.camel@maggy.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Nov 2010 11:28:11 -0800
Message-ID: <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 10:10 AM, Mike Galbraith <efault@gmx.de> wrote:
>
> Oh well, yesterday ping (one of sister's laptop loving cats) opened
> _187_ screenshots while I was away from the keyboard.  I'll blame any
> spelling errors on him too while I'm at it :)
>
> Here's a fresh copy, no cats is sight.

This catless version looks very good to me. Assuming testing and
approval by the scheduler people, this has an enthusiastic "ack" from
me.

                         Linus

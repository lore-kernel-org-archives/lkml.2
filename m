Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab0KPTD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:03:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54252 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab0KPTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JdVez2gW4ULJZRY7ifKfA82iZqVb78vyTbggyMSlxk7sipMThKspCGCf6GHz0gLtef
         HeAEmxFHOh2mN/65CY6P2+LwvD3s3FEOlB3monxAkIddTzRTUXpO2fBIWwhwJp94RmG5
         AUbyiWouOicAJfowkgLzEoEZfwAP2KIT6aOc8=
MIME-Version: 1.0
In-Reply-To: <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
References: <1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116015648.GA11534@redhat.com>
	<1289916171.5169.117.camel@maggy.simson.net>
	<1289916683.2109.625.camel@laptop>
	<AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	<20101116170312.GA19327@tango.0pointer.de>
	<AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	<20101116181603.GC19327@tango.0pointer.de>
	<AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
Date: Tue, 16 Nov 2010 21:03:57 +0200
X-Google-Sender-Auth: kdOdl6WxwX-sl7tzPnTDwCs_w5M
Message-ID: <AANLkTi=Z5CK3fOgXNs9odKnQNFHsbavpOvw8c3kh6zEG@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 8:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> User-level configuration for something that should just work is
> annoying. We can do better.

Completely agreed. Desktop users should not be required to fiddle with
kernel knobs from userspace to fix interactivity problems. Having sane
defaults applies to the kernel as much as it does to userspace.

                        Pekka

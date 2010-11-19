Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0KSMcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:32:16 -0500
Received: from smtp-out.google.com ([74.125.121.35]:54880 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0KSMcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dkFupRExqIuyWilliR6TzB+2GED2lwFgPBQZ3CZqnafC9nZAFzCfcRmFPHWr0d+QHB
         bIdk53W76YV2e8V7T9GA==
MIME-Version: 1.0
In-Reply-To: <1290167376.2109.1553.camel@laptop>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
 <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net>
 <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net>
 <20101118234339.GA6024@const.famille.thibault.fr> <1290167376.2109.1553.camel@laptop>
From: Paul Menage <menage@google.com>
Date: Fri, 19 Nov 2010 04:31:50 -0800
Message-ID: <AANLkTikB6QXxTav=b7qNzHUv4HXnjjT9TdcEdTYHbEkw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 3:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> It must be nice to be that ignorant ;-) Speaking for the scheduler
> cgroup controller (that being the only one I actually know), most all
> the load-balance operations are O(n) in the number of active cgroups,
> and a lot of the cpu local schedule operations are O(d) where d is the
> depth of the cgroup tree.

The same would apply to CPU autogroups, presumably?

Paul

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0CZMxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0CZMxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:53:21 -0400
Date: Fri, 26 Mar 2010 18:19:01 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Anton Blanchard <anton@samba.org>,
       tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
	hvc_remove
Message-ID: <20100326124901.GC7039@amit-x200.redhat.com>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-4-git-send-email-gregkh@suse.de> <1269119079.8599.65.camel@pasglop> <20100321043725.GA21566@amit-x200.redhat.com> <20100324121902.GJ15789@amit-x200.redhat.com> <4BAC7AD4.4030309@in.ibm.com> <20100326095821.GA7039@amit-x200.redhat.com> <4BAC9D9E.5070901@in.ibm.com> <20100326115233.30288d3c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326115233.30288d3c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) Mar 26 2010 [11:52:33], Alan Cox wrote:
> > >> mount: can't find /root/proc in /etc/fstab or /etc/mtab
> > >> /sbin/smart_agetty: can not determine 'console' speed
> > >>     
> > >
> > > OK, this gets even murkier. I don't know why taking a few krefs modifies
> > > hvc_console behaviour to such an extent.
> 
> Can you see if the agetty is getting a hangup or open failing. I wonder
> if its just a timing change ?

Can someone please try this? Looks like it only reproduces on ppc, I
can't get it to reproduce in my kvm vm. I'm trying to get hold of a ppc
box, though. (btw ppc, ppc64, both should trigger this, right?)

		Amit

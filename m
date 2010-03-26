Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab0CZLvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 07:51:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35254 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751028Ab0CZLvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 07:51:06 -0400
Date: Fri, 26 Mar 2010 11:52:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Amit Shah <amit.shah@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Anton Blanchard <anton@samba.org>,
       tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
 hvc_remove
Message-ID: <20100326115233.30288d3c@lxorguk.ukuu.org.uk>
In-Reply-To: <4BAC9D9E.5070901@in.ibm.com>
References: <20100319151326.GC8541@kroah.com>
	<1269011916-8836-4-git-send-email-gregkh@suse.de>
	<1269119079.8599.65.camel@pasglop>
	<20100321043725.GA21566@amit-x200.redhat.com>
	<20100324121902.GJ15789@amit-x200.redhat.com>
	<4BAC7AD4.4030309@in.ibm.com>
	<20100326095821.GA7039@amit-x200.redhat.com>
	<4BAC9D9E.5070901@in.ibm.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> mount: can't find /root/proc in /etc/fstab or /etc/mtab
> >> /sbin/smart_agetty: can not determine 'console' speed
> >>     
> >
> > OK, this gets even murkier. I don't know why taking a few krefs modifies
> > hvc_console behaviour to such an extent.

Can you see if the agetty is getting a hangup or open failing. I wonder
if its just a timing change ?

Alan

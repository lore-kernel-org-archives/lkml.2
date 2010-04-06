Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0DFMaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:30:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37834 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752081Ab0DFMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:30:00 -0400
Date: Tue, 6 Apr 2010 13:32:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Blanchard <anton@samba.org>
Cc: Amit Shah <amit.shah@redhat.com>, Sachin Sant <sachinp@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
 hvc_remove
Message-ID: <20100406133217.61347573@lxorguk.ukuu.org.uk>
In-Reply-To: <20100406114238.GN5594@kryten>
References: <20100319151326.GC8541@kroah.com>
	<1269011916-8836-4-git-send-email-gregkh@suse.de>
	<1269119079.8599.65.camel@pasglop>
	<20100321043725.GA21566@amit-x200.redhat.com>
	<20100324121902.GJ15789@amit-x200.redhat.com>
	<4BAC7AD4.4030309@in.ibm.com>
	<20100326095821.GA7039@amit-x200.redhat.com>
	<4BAC9D9E.5070901@in.ibm.com>
	<20100326124340.GB7039@amit-x200.redhat.com>
	<20100406114238.GN5594@kryten>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't claim to understand the tty layer, but it seems like hvc_open and
> hvc_close should be balanced in their kref reference counting.

They should yes.


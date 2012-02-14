Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2BNSae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:30:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977Ab2BNSab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:30:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1329242378.3675.71.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1329242378.3675.71.camel@mfleming-mobl1.ger.corp.intel.com> <1329219673-28711-21-git-send-email-matt@console-pimps.org> <1329219673-28711-1-git-send-email-matt@console-pimps.org> <17603.1329234976@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-am33-list@redhat.com
Subject: Re: [PATCH 20/40] mn10300: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 18:30:10 +0000
Message-ID: <28189.1329244210@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Matt Fleming <matt@console-pimps.org> wrote:

> > Can this line create a race, now that it's not protected by a lock?  It is
> > possible for current->blocked to get altered by another thread.
> 
> ->blocked can only ever be altered by current, not another thread. See
> the following comment from sigprocmask() in kernel/signal.c,

Okay, I've managed to convince myself.  Feel free to my Acked-by to the
MN10300 and FRV patches.

David

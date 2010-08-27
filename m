Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0H0NXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab0H0NXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:23:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8762ywgqkt.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
References: <8762ywgqkt.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me> <87aao8gvbm.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me> <1282902149-12991-15-git-send-email-namhyung@gmail.com> <1282902149-12991-1-git-send-email-namhyung@gmail.com> <4072.1282906906@redhat.com> <5542.1282911123@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 14/43] ptrace, frv: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 14:23:10 +0100
Message-ID: <7665.1282915390@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> wrote:

> In this series, 3/43 changes the prototype of arch_ptrace() in
> include/linux/ptrace.h and the following patches change it for each arch in
> arch/xxx/kernel/ptrace.c. Do you mean all of arch change patches should be
> combinded into a patch?

If patch 3 breaks all architectures, such that none of them then compile, this
is bad.  The fixes should be combined into that patch.

If it breaks them such that there are warnings, but they still compile, we can
probably live with that, but it's still icky.

David

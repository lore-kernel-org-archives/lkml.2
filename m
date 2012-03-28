Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2C1ROt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:14:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab2C1ROs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:14:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4F728F8D.1010505@zytor.com>
References: <4F728F8D.1010505@zytor.com> <20120327153424.23373.25880.stgit@warthog.procyon.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Disintegrate asm/system.h for X86
Date: Wed, 28 Mar 2012 18:14:36 +0100
Message-ID: <2736.1332954876@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> Are you planning to push this as part of a bigger set or do you want me
> to pick up this one?

I would actually prefer the patch to go through the arch tree - provided it
gets to Linus in this window.  It oughtn't to matter if Linus gets it by two
different routes as GIT should cope with that.

However, if you aren't going to ask Linus to pull again this window, then
leave it for the moment and I'll try to push it.  If Linus doesn't pick it up
in this window, then I'll ask you to pull it in time for the next.

David

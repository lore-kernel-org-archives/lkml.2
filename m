Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2LQMwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:52:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2LQMwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:52:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFxxC8xpG9KQtqxRfcJzCu58Fv711bTwtKFq3HHAvRhYBA@mail.gmail.com>
References: <CA+55aFxxC8xpG9KQtqxRfcJzCu58Fv711bTwtKFq3HHAvRhYBA@mail.gmail.com> <alpine.LRH.2.02.1212151925410.27388@tundra.namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [GIT] Security subsystem updates for 3.8
Date: Mon, 17 Dec 2012 12:52:05 +0000
Message-ID: <2569.1355748725@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > A quiet cycle for the security subsystem with just a few maintenance
> > updates.
> 
> Ok, pulled. There were a few trivial conflicts (mostly due to some of
> the key allocation patches having already been merged, and some of the
> kuid/kgid changes due to the userns changes).
> 
> I'd like you to double-check the end result, but it *looks* fine.
> Adding both EricB and DavidH to the participants since the conflicts
> were generally due to intetractions with their patches.

There seemed to be a couple of minor bits that got lost.  I'm not sure where,
though.  I'll send them to you as additional patches.  Other than that,
everything appears to have merged okay.

David

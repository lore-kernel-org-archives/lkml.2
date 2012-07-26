Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2GZKqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2GZKqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:46:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHO5Pa1yOxBhorYBGJUsy8MehRUbbrwc=uq7Vs+bevtCXGjGMQ@mail.gmail.com>
References: <CAHO5Pa1yOxBhorYBGJUsy8MehRUbbrwc=uq7Vs+bevtCXGjGMQ@mail.gmail.com> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk> <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com> <28702.1343135952@warthog.procyon.org.uk> <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com> <6193.1343211798@warthog.procyon.org.uk> <CAHO5Pa2ck_wqUwiuFUxEeU=k3dJvByyjpygpUhrSFRsMyBZ8Eg@mail.gmail.com> <5901.1343244093@warthog.procyon.org.uk>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 00/13] UAPI header file split
Date: Thu, 26 Jul 2012 11:46:04 +0100
Message-ID: <19738.1343299564@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> >> >> 3. HEADER COMMENTS NOT RETAINED IN KAPI FILES
> >
> > How about the attached changes?  This is a delta to the disintegrate markers
> > diff I sent earlier.
> 
> That looks about right to me.
> 
> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

Excellent, thanks.  The question is where can I attach your ack?  I'm not
going to simply tag these on the end as a new patch, but rather the changes
are included in the regenerated patches as I changed the scripts.

So just the main set of scripted commits?

David

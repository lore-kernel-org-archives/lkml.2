Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2GYUJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab2GYUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:09:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5901.1343244093@warthog.procyon.org.uk>
References: <5901.1343244093@warthog.procyon.org.uk> <CAHO5Pa2ck_wqUwiuFUxEeU=k3dJvByyjpygpUhrSFRsMyBZ8Eg@mail.gmail.com> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk> <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com> <28702.1343135952@warthog.procyon.org.uk> <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com> <6193.1343211798@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 00/13] UAPI header file split
Date: Wed, 25 Jul 2012 21:09:00 +0100
Message-ID: <6793.1343246940@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > >> 3. HEADER COMMENTS NOT RETAINED IN KAPI FILES
> 
> How about the attached changes?  This is a delta to the disintegrate markers
> diff I sent earlier.

See the duplicated-important-banners tag in my GIT tree.

David

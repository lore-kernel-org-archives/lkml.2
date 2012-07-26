Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2GZPWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:22:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab2GZPWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:22:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHO5Pa3yQQH+Wc-G=u4EncCt2O6vLdNDe=rV8wEgHvQowzk0ZQ@mail.gmail.com>
References: <CAHO5Pa3yQQH+Wc-G=u4EncCt2O6vLdNDe=rV8wEgHvQowzk0ZQ@mail.gmail.com> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk> <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com> <28702.1343135952@warthog.procyon.org.uk> <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com> <6193.1343211798@warthog.procyon.org.uk> <CAHO5Pa2ck_wqUwiuFUxEeU=k3dJvByyjpygpUhrSFRsMyBZ8Eg@mail.gmail.com> <12201.1343215232@warthog.procyon.org.uk> <CAHO5Pa1rCV+Od4q3SVHbGf_08q1uAeaNZEHH6NEuouviOS0awA@mail.gmail.com> <6228.1343313133@warthog.procyon.org.uk>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 00/13] UAPI header file split
Date: Thu, 26 Jul 2012 16:22:20 +0100
Message-ID: <25789.1343316140@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> I haven't looked over the changes yet, but what do my scripts now say?
> (If all's well, they generate no output beyond the list of files.)

Okay, the comparator script gives me:

	warthog>sh /tmp/mtk-cmp.sh 
	======== include/linux/irqnr.h include/uapi/linux/irqnr.h
		 * Generic irq_desc iterators:

That loss I can live with, and so can Thomas.  I suspect the comment is in the
wrong place anyway, so it can be added back after in the right place.

David

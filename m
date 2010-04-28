Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0D1PCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab0D1PCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:02:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <v2x412e6f7f1004280753pd3438a3fv860edc580ecd6185@mail.gmail.com>
References: <v2x412e6f7f1004280753pd3438a3fv860edc580ecd6185@mail.gmail.com> <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> <8526.1272447122@redhat.com> <q2r412e6f7f1004280656t331e9120rc9eab069fb4d4de3@mail.gmail.com> <6096.1272463619@redhat.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Wed, 28 Apr 2010 16:00:06 +0100
Message-ID: <14370.1272466806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao <xiaosuo@gmail.com> wrote:

> > How often do the two actually mix?  And if they do, is that really an
> > error?
> 
> The sock.sk_sleep is used by exclusive and non-exclusive wait queues.
> exclusive and non-exclusive is identified by wait queues, not wait
> queue heads. Maybe there is a historical reason. It is much like a
> hack.

But is it actually used in both modes at the same time?

David

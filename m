Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0EUIHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0EUIHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:07:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTimmqYpeIrb9N60gk6LgAfeGjv_65Ikb1yfdxeE8@mail.gmail.com>
References: <AANLkTimmqYpeIrb9N60gk6LgAfeGjv_65Ikb1yfdxeE8@mail.gmail.com> <1274135154-24082-1-git-send-email-walken@google.com> <1274135154-24082-4-git-send-email-walken@google.com> <5592.1274271931@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 03/10] rwsem: lighter active count checks when waking up readers
Date: Fri, 21 May 2010 09:06:26 +0100
Message-ID: <19357.1274429186@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> down_xxxx can increase the active count ...

Not so much can, as does...  Perhaps you need to qualify that.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab0EMCyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:54:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57018 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0EMCyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:54:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=B1HZpTweP3O23pUEjU8MHUY8K/TgvabUroEiOEXr75zROu7MUI/MTbKiUgTnXoCAq
	zLxp/q36rMd0bVthKSQDA==
MIME-Version: 1.0
In-Reply-To: <29724.1273668156@redhat.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
	 <1273634462-2672-9-git-send-email-walken@google.com>
	 <29724.1273668156@redhat.com>
Date: Wed, 12 May 2010 19:54:33 -0700
Message-ID: <i2q8d20b11a1005121954l4c8e59al5487c2e34b0fcad3@mail.gmail.com>
Subject: Re: [PATCH 08/12] rwsem: smaller wrappers around rwsem_down_failed_common
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 5:42 AM, David Howells <dhowells@redhat.com> wrote:
> Michel Lespinasse <walken@google.com> wrote:
>
>> Following change also enjoys having flags available in a register rather
>> than having to fish it out in the struct rwsem_waiter...
>
> So what?  It doesn't use flags in rwsem_down_failed_common().

I meant patch 10 wants to use the flags in order to know whether to
queue at the head or tail of the waiter list.

Apologies for the compile error, patches 8 and 10 used to be a single
change and were split off relatively late. :/

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

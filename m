Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377Ab2DLJgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab2DLJgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:36:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120412024810.GA17984@redhat.com>
References: <20120412024810.GA17984@redhat.com> <20120412024751.GA17561@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org, chris@zankel.net
Subject: TIF_NOTIFY_RESUME [was Re: [PATCH v2 1/2] task_work_queue: add generic process-context callbacks]
Date: Thu, 12 Apr 2012 10:35:42 +0100
Message-ID: <9335.1334223342@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg Nesterov <oleg@redhat.com> wrote:

> +#ifdef TIF_NOTIFY_RESUME

If we're going to keep this feature, I wonder if it's worth just requiring the
arches lacking this feature to add it at this point, rather than adding all
this conditional logic.

It doesn't look like it should be too hard for m68k, but xtensa looks tricky.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2DSQwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab2DSQwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:52:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120417193409.GA20312@redhat.com>
References: <20120417193409.GA20312@redhat.com> <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com> <20120417163606.GC14527@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] cred: change keyctl_session_to_parent() to use task_work_add()
Date: Thu, 19 Apr 2012 17:52:13 +0100
Message-ID: <23383.1334854333@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> +#define key_replace_session_keyring()	do { } while (0)
> +

Ummm... Why?  You've made the function no longer exist and so this shouldn't be
there anymore.  You shouldn't just leave the call sites in place.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2DSTex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:34:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2DSTev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:34:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120419184013.GA31862@redhat.com>
References: <20120419184013.GA31862@redhat.com> <20120419173431.GA27066@redhat.com> <20120417193409.GA20312@redhat.com> <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com> <20120417163606.GC14527@redhat.com> <23383.1334854333@redhat.com> <25695.1334858133@redhat.com> <20120419181010.GA29793@redhat.com> 
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
Date: Thu, 19 Apr 2012 20:34:18 +0100
Message-ID: <27773.1334864058@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> I am not going to argue, but honestly I don't think it is a good
> idea to mix the functional changes in keyctl.c and the simple
> (but obviously untested) cleanups.

I meant add the cleanup as patch 4.  That way they are still separate.  I'll
let you change the name of the function to make it easier;-)

David

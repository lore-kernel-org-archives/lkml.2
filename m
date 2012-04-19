Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2DSRzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:55:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab2DSRzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:55:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120419173431.GA27066@redhat.com>
References: <20120419173431.GA27066@redhat.com> <20120417193409.GA20312@redhat.com> <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com> <20120417163606.GC14527@redhat.com> <23383.1334854333@redhat.com>
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
Date: Thu, 19 Apr 2012 18:55:33 +0100
Message-ID: <25695.1334858133@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> But I certainly do not want to put these changes in 3/3 or in this series.

Why not?  It seems the correct place for them.

David

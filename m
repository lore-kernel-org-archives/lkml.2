Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab0DJIQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 04:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab0DJIQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 04:16:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100409195936.44663BD18@magilla.sf.frob.com>
References: <20100409195936.44663BD18@magilla.sf.frob.com> <20100322184136.GA3967@redhat.com> <15829.1269333449@redhat.com> <20100323105707.GA8634@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
Date: Sat, 10 Apr 2010 09:16:19 +0100
Message-ID: <9905.1270887379@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> I'm not so sure.  Operations like sigprocmask and sigaction really have
> always been entirely atomic from the userland perspective before.  Now it
> becomes possible to read from /proc e.g. a blocked set that never existed
> as such (one word updated by sigprocmask but not yet the next word).

If you have a small userspace buffer, that was previously possible too.

David

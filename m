Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0CWIac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab0CWIaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:30:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100322184136.GA3967@redhat.com>
References: <20100322184136.GA3967@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
Date: Tue, 23 Mar 2010 08:30:16 +0000
Message-ID: <15714.1269333016@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Also, remove the "is this correct?" comment. I think it is safe
> to dereference __task_cred(p)->user under rcu lock.

It is.

David

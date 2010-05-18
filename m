Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab0ERIzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab0ERIzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:55:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100517195414.GA21504@redhat.com>
References: <20100517195414.GA21504@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Tridgell <tridge@samba.org>, Eric Paris <eparis@parisplace.org>,
       Jakub Jelinek <jakub@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: don't check creds if same_thread_group()
Date: Tue, 18 May 2010 09:55:07 +0100
Message-ID: <2996.1274172907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Also, move "cred = current_cred()" down to avoid calling get_current()
> twice.

I don't see what you mean by this.  same_thread_group() doesn't call
current_cred(), so why this change?

David

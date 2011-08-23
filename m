Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1HWHgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:36:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab1HWHgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:36:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1314084231.5033.1.camel@phoenix>
References: <1314084231.5033.1.camel@phoenix>
To: Axel Lin <axel.lin@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] CRED: fix build error due to 'tgcred' undeclared
Date: Tue, 23 Aug 2011 08:36:27 +0100
Message-ID: <25044.1314084987@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> wrote:

> This patch adds CONFIG_KEYS guard for tgcred to fix below build error
> if CONFIG_KEYS is not configured.
> 
>   CC      kernel/cred.o
> kernel/cred.c: In function 'prepare_kernel_cred':
> kernel/cred.c:657: error: 'tgcred' undeclared (first use in this function)
> kernel/cred.c:657: error: (Each undeclared identifier is reported only once
> kernel/cred.c:657: error: for each function it appears in.)
> make[1]: *** [kernel/cred.o] Error 1
> make: *** [kernel] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>

James: do you want me to reissue my patches?

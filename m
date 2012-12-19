Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2LSNTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:19:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab2LSNTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:19:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <836be70329567778096e6a5b9e898a85238b382c.1355879564.git.joe@perches.com>
References: <836be70329567778096e6a5b9e898a85238b382c.1355879564.git.joe@perches.com> <28860.1355870146@warthog.procyon.org.uk>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] checkpatch: Warn on uapi #includes that #include <uapi/...
Date: Wed, 19 Dec 2012 13:18:48 +0000
Message-ID: <12465.1355923128@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Avoid specifying internal uapi #include paths with uapi/...
> as userspace should not use and never see that.
> 
> Neaten message line wrapping above.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: David Howells <dhowells@redhat.com>

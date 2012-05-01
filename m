Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2EAUmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:42:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2EAUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:42:16 -0400
Date: Tue, 1 May 2012 13:42:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
Message-Id: <20120501134214.f6b44f4a.akpm@linux-foundation.org>
In-Reply-To: <m1zk9rmyh4.fsf@fess.ebiederm.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com>
	<m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2012 13:35:03 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> Andrew can you please pick up this patch?

Sure.  I assume it's fixing a post-3.4 regression?  No -stable backport
needed?

> This doesn't explain all of the vsftp weirdness people have been seeing
> but it does fix a real leak on fork failure that vsftp could most
> definitely have triggered.
> 
> Mike Galbraith <efault@gmx.de> writes:

hm, Mike had some test code.  If that was put in
tools/testing/selftests/nsproxy, this leak wouldn't happen again!

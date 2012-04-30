Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2D3DZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 23:25:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51644 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755082Ab2D3DZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 23:25:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wPUFGo7qwBXB845418d/XeRrqi/8Ox4+RfEEecg
	bQzaR6P3Ix9FDp
Message-ID: <1335756337.17899.9.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Mon, 30 Apr 2012 05:25:37 +0200
In-Reply-To: <m11un5zzzb.fsf@fess.ebiederm.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com> <m11un5zzzb.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 19:59 -0700, Eric W. Biederman wrote: 
> Oleg Nesterov <oleg@redhat.com> writes:

> > Yes, but please note that this change also checks "new == NULL", so I
> > still think the patch is correct.
> 
> Sort of.  It is correct in the sense that it performs magic checks on
> it's arguments to see that it's caller is exit_task_namespaces called
> from the fork failure path.

Yeah, did that to keep namespace fix in namespace source.  Bad idea even
with circles and arrows "hey, I'm an unborn red-headed stepchild".

-Mike




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2EDIyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:54:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47568 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753245Ab2EDIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:54:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/doLN+UBfddF3QjJFvarNin5L5YexJEruab/Udpo
	za8lMl1b2j2p21
Message-ID: <1336121673.25479.28.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri, 04 May 2012 10:54:33 +0200
In-Reply-To: <1336119571.25479.6.camel@marge.simpson.net>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
	 <1336057018.8119.46.camel@marge.simpson.net>
	 <m1sjfggyp3.fsf@fess.ebiederm.org>
	 <1336119571.25479.6.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 10:19 +0200, Mike Galbraith wrote: 
> On Fri, 2012-05-04 at 01:03 -0700, Eric W. Biederman wrote: 

> > Are you saying all known bugs are fixed?

> Think so.  I'm beating it up in our 3.0 kernel with all fixes, since the
> patch that started this odyssey got backported to that kernel as well.

Yeah, it's dead.

	-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0DUNWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:22:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43781 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab0DUNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:22:07 -0400
Date: Wed, 21 Apr 2010 08:21:52 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Message-ID: <20100421132152.GA16326@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421030406.GB10258@kroah.com>
 <20100421034532.GA9254@us.ibm.com>
 <m1zl0xo1m9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zl0xo1m9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Can we make this a trivial filesystem?  I expect that would match
> up better with whatever plan9 userspace apps already exist,
> remove the inode double translation, and would make it much more
> reasonable to do a user namespace aware version  if and when
> that becomes necessary.

Great idea, and so obvious once you mention it.  I think that's
the way to go.  Thanks, Eric.

-serge

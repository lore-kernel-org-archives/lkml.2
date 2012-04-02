Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab2DBIZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:25:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52096 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2DBIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:25:45 -0400
Date: Mon, 2 Apr 2012 01:25:40 -0700
From: Joel Becker <jlbec@evilplan.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: ocfs2-users@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Ocfs2-users] BUG at fs/ocfs2/extent_map.c:476
Message-ID: <20120402082539.GA10228@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: richard -rw- weinberger <richard.weinberger@gmail.com>,
	ocfs2-users@oss.oracle.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CAFLxGvy+9eHbjsAm-FaV8ihXexGGLURbyDTd6X_pqE_mtOutcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvy+9eHbjsAm-FaV8ihXexGGLURbyDTd6X_pqE_mtOutcw@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 09:50:49AM +0100, richard -rw- weinberger wrote:
> Hi!
> 
> Today one of my kvm hosts ran into this BUG.
> The host is member of y small ocfs2-cluster (3 hosts).
> CentOS 6.2, Kernel 3.1.1 (vanilla).
...
> Is this a known/fixed bug?

Not that I know of.  Have you seen it more than once?

Joel

-- 

None of our men are "experts."  We have most unfortunately found
it necessary to get rid of a man as soon as he thinks himself an
expert -- because no one ever considers himself expert if he really
knows his job.  A man who knows a job sees so much more to be done
than he has done, that he is always pressing forward and never
gives up an instant of thought to how good and how efficient he is.
Thinking always ahead, thinking always of trying to do more, brings
a state of mind in which nothing is impossible. The moment one gets
into the "expert" state of mind a great number of things become
impossible.
	- From Henry Ford Sr., "My Life and Work"

			http://www.jlbec.org/
			jlbec@evilplan.org

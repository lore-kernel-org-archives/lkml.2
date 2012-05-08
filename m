Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2EHAia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:38:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50280 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2EHAi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:38:28 -0400
Date: Mon, 7 May 2012 17:38:23 -0700
From: Joel Becker <jlbec@evilplan.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: ocfs2-users@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Ocfs2-users] BUG at fs/ocfs2/extent_map.c:476
Message-ID: <20120508003822.GH4713@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: richard -rw- weinberger <richard.weinberger@gmail.com>,
	ocfs2-users@oss.oracle.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CAFLxGvy+9eHbjsAm-FaV8ihXexGGLURbyDTd6X_pqE_mtOutcw@mail.gmail.com>
 <20120402082539.GA10228@dhcp-172-17-9-228.mtv.corp.google.com>
 <CAFLxGvyjVnMX6jLvGWtyup1EddFn73MUq_FkFsYBBuUNpKXrYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLxGvyjVnMX6jLvGWtyup1EddFn73MUq_FkFsYBBuUNpKXrYg@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 10:36:53AM +0200, richard -rw- weinberger wrote:
> On Mon, Apr 2, 2012 at 10:25 AM, Joel Becker <jlbec@evilplan.org> wrote:
> > On Sat, Mar 24, 2012 at 09:50:49AM +0100, richard -rw- weinberger wrote:
> >> Hi!
> >>
> >> Today one of my kvm hosts ran into this BUG.
> >> The host is member of y small ocfs2-cluster (3 hosts).
> >> CentOS 6.2, Kernel 3.1.1 (vanilla).
> > ...
> >> Is this a known/fixed bug?
> >
> > Not that I know of.  Have you seen it more than once?
> >
> 
> No. All three cluster members had an uptime of 70 days.
> Only one showed the BUG.
> I've rebooted it and it seems to work fine now.
> 
> I'm not an ocfs2 expert, what could cause this kind of BUG?
> Internal logic error? Filesystem corruption?

	No idea.  That's the problem.  More details would be nice, but I
suspect you'd rather not crash again :-)

Joel

-- 

"Soap and education are not as sudden as a massacre, but they are more
 deadly in the long run."
	- Mark Twain


			http://www.jlbec.org/
			jlbec@evilplan.org

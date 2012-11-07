Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2KGQxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:53:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2KGQxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:53:00 -0500
Date: Wed, 7 Nov 2012 08:52:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, Adil Mujeeb <mujeeb.adil@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] checkpatch: Emit an warning when floating point
 values are used
Message-Id: <20121107085258.3a46f45f.akpm@linux-foundation.org>
In-Reply-To: <1352286575.4164.2.camel@joe-AO722>
References: <cover.1351736873.git.joe@perches.com>
	<359a78054bc0dfaedede95222781b4177d3c33ce.1351736873.git.joe@perches.com>
	<20121106153625.c48ba1f1.akpm@linux-foundation.org>
	<1352286575.4164.2.camel@joe-AO722>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2012 03:09:35 -0800 Joe Perches <joe@perches.com> wrote:

> On Tue, 2012-11-06 at 15:36 -0800, Andrew Morton wrote:
> > On Thu,  1 Nov 2012 00:12:18 -0700
> > Joe Perches <joe@perches.com> wrote:
> > > Linux kernel doesn't like floating point, say so. 
> []
> > > --- a/scripts/checkpatch.pl
> > > +++ b/scripts/checkpatch.pl
> > > @@ -2332,6 +2332,13 @@ sub process {
> > >  			     "do not add new typedefs\n" . $herecurr);
> > >  		}
> > >  
> > > +# check for floating point constants
> > > +
> > > +		if ($line =~ /\b$Float\b/) {
> > > +			WARN("KERNEL_FLOAT",
> > > +			     "Floating point is not supported in linux kernel source\n" . $herecurr);
> > > +		}
> > > +
> > >  # * goes on variable not on type
> > >  		# (char*[ const])
> > >  		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
> > 
> > The earlier review comments were not addressed.
> 
> You didn't read my response in the thread then.

There was no response afaict.  Not here, not on lkml.org?



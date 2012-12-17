Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2LQPfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:35:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52346 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752175Ab2LQPfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:35:44 -0500
Message-ID: <1355758544.13361.14.camel@joe-AO722>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Date: Mon, 17 Dec 2012 07:35:44 -0800
In-Reply-To: <20121217102714.GB31947@liondog.tnic>
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
	 <50CEF080.8010208@suse.cz> <20121217102714.GB31947@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 11:27 +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 11:14:24AM +0100, Michal Marek wrote:
> > On 14.12.2012 23:19, Cesar Eduardo Barros wrote:
> > > This small script checks the file patterns in the MAINTAINERS file.
> > > 
> > > For every file pattern, it checks if the pattern matches any file or
> > > directory in the kernel tree, printing the patterns which do not have a
> > > match.
> > 
> > Can't this be added as a warning to scripts/get_maintainer.pl instead?
> 
> Yep, it definitely makes more sense than having a standalone script.

I'm not so sure of that myself.

I think maybe it should go into checkpatch.

I do have a similar script as a get_maintainers variant.

Adding a --verify-patterns option seems off-topic to
the generic tool use of get_maintainers.

There's a fair amount of tedium for people to do more
than determine there is a pattern that doesn't match
files in git.

Doing the work that Cesar did to find the commit that
makes a pattern valid/invalid when renames or deletions
occur is the chore that could be automated.

Perhaps Cesar can use his script as a starting point
to find those pattern invalidating commits or maybe
add the capability (or a --strict check) to checkpatch.



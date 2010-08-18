Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0HRQmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:42:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0HRQmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:42:45 -0400
Date: Wed, 18 Aug 2010 12:42:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Andreas Gruenbacher <agruen@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: Re: [GIT PULL] notification tree: directory events
Message-ID: <20100818164230.GA26034@infradead.org>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
 <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
 <201008162232.36873.agruen@suse.de>
 <201008181747.15461.agruen@suse.de>
 <1282147146.21419.165.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282147146.21419.165.camel@acb20005.ipt.aol.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 11:59:06AM -0400, Eric Paris wrote:
> Thus far your e-mails have pointed out one bug in the permissions
> implementation I am currently working fixing and a bunch of complaining
> about features you can imagine someone might someday want but which
> noone has actually stood up and said 'I will use this' or 'this sucks
> for my use case'.  I can find all sorts of things around the kernel
> where I can imagine some mythical users might want to do something
> different but it isn't a reason to prevent merger.  I'd love to have
> more review, I'm certainly going to look at your wish list, but don't
> expect response to future trolling messages.

Eric, please stop that crap.  You've sent a pull request for stuff
that's not only been contentious but also not reviewed at all in this
form to Linus behind everyones back.  Andreas actually takes his time
to review the clusterfuck you created, so better be really quite and
listen to him. 


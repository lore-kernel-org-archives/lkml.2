Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230Ab0HGAGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:06:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0HGAG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:06:29 -0400
Date: Fri, 6 Aug 2010 20:06:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Subject: Re: [GIT PULL] notification tree - try 37!
Message-ID: <20100807000624.GA14819@infradead.org>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
 <20100806233431.GW2927@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806233431.GW2927@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 04:34:31PM -0700, Matt Helsley wrote:
> On Fri, Aug 06, 2010 at 11:58:39AM -0400, Eric Paris wrote:
> > Here it is again!  Another notification pull request!  There is still
> > future work to be done on notification, but nothing that I believe
> > others would call blocking or functional.  The work I plan to do
> > includes:
> > 
> > 1) Al has discussed the addition of a file_clone() call in the VFS which
> > would eliminate my use of __dentry_open() and would allow the removal of
> > the rather hideous FMODE_/O_NONOTIFY.
> 
> I did a quick search and can't find a mailing list post on this. Was
> it a private discussion or is there something I can read about what
> file_clone() will do?

I'm also totally missing on any re-post of these patches or discussion
of the changes during the last development window.


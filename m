Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab0DVV56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:57:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab0DVV54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:57:56 -0400
Date: Thu, 22 Apr 2010 23:57:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Francis Galiegue <fgaliegue@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Should I really bother all maintainers with this?
In-Reply-To: <y2lac542ca01004221444le9b33c8as587d3382ab7ff0a9@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1004222357150.7579@pobox.suse.cz>
References: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>  <p2v8bd0f97a1004221421x4bf0850fm1b47f4838c344368@mail.gmail.com> <y2lac542ca01004221444le9b33c8as587d3382ab7ff0a9@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010, Francis Galiegue wrote:

> >> This patch only fixes quite a common mistake in Documentation/, and if I
> >> scripts/get_maintainer.pl on the patch (which is recommended), I potentially
> >> mail thousands of people who probably have more useful/exciting stuff to do
> >> anyway. So, I submit it as is.
> >
> > this kind of stuff usually goes through the trivial tree.  look at
> > TRIVIAL PATCHES in the MAINTAINERS file.
> > -mike
> >
> 
> Point taken... But the patch doesn't apply as is over trivial/master or
> trivial/for-next, as two files don't seem to exist on either branch (trivial
> being the git repository mentioned in MAINTAINERS):
> Documentation/DMA-API-HOWTO.txt and Documentation/filesystems/ceph.txt.

That's not a problem, I pull Linus' tree into my tree when needed. Just 
resend the patch (based on Linus' tree) to trivial@kernel.org and I'll 
process it appropriately.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

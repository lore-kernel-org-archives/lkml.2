Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0JHPMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:12:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab0JHPMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:12:22 -0400
Date: Fri, 8 Oct 2010 11:12:20 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Michal Marek <mmarek@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org, aris@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] kbuild: fix oldnoconfig to do the right thing
Message-ID: <20101008151220.GB24144@bombadil.infradead.org>
References: <20100901152130.GY2684@bombadil.infradead.org>
 <20100905061758.GA29547@merkur.ravnborg.org>
 <20100908115553.GC2617@sepie.suse.cz>
 <20101008143642.GA24144@bombadil.infradead.org>
 <4CAF30AE.3040305@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAF30AE.3040305@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:54:38PM +0200, Michal Marek wrote:
> Oh, sorry, I didn't realize that this is a regression from 2.6.35 and
> applied it to the kconfig branch, which is part of for-next. I'll try to
> send a pull request with this patch and two other later today, but I
> don't know if Linus is going to accept it.
> 

It's not a regression from .35, just trying to avoid unexpected changes
to how parts of the build system work after release (which means it
could be perceived as a regression from .36 to .37)

IE: Someone begins to expect this behaviour in 2.6.36, and then
 the patch goes into 2.6.37-rc1, so 2.6.37 behaves differently.

regards, Kyle

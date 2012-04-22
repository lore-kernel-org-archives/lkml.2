Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2DVUF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:05:58 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:12889 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2DVUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:05:57 -0400
Date: Sun, 22 Apr 2012 22:05:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, tj@kernel.org, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120422200554.GA6385@merkur.ravnborg.org>
References: <20120420191418.GA3569@merkur.ravnborg.org> <CAE9FiQU-M0yW_rwysq56zrZzift=PxgwioMmx8bMcJ5o20m2TQ@mail.gmail.com> <20120420194309.GA3689@merkur.ravnborg.org> <20120422.152210.1520263792125579554.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120422.152210.1520263792125579554.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 03:22:10PM -0400, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 20 Apr 2012 21:43:09 +0200
> 
> > I have it almost finished - except that it does not work :-(
> > We have limitations in what area we can allocate very early,
> > and here I had to use the alloc_bootmem_low() variant.
> > I had preferred a variant that allowed me to allocate
> > bottom-up in this case.
> 
> I think you're going to have to bear down and map all of linear kernel
> mappings before you start using the bootmem code rather than
> afterwards.

Thanks - I will try to do so.
But I must admit I do not (yet) see any big difference in the
approach before/after.

I digged up an old todo regarding final link of vmlinux.
Will look at this and then re-visit memblock at sparc32.

	Sam

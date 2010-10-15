Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0JOJKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:10:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab0JOJK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:10:29 -0400
Date: Fri, 15 Oct 2010 11:10:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Greg KH <greg@kroah.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
        stable@kernel.org, Alan Ott <alan@signal11.us>
Subject: Re: [stable] [PATCH 0/2] HID: hidraw, fix two NULL pointer
 dereferences
In-Reply-To: <20101015094436.50ab68f3.ospite@studenti.unina.it>
Message-ID: <alpine.LNX.2.00.1010151109400.6879@pobox.suse.cz>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz> <1286292017-6746-1-git-send-email-ospite@studenti.unina.it> <20101005174200.GB29937@kroah.com> <20101005221619.88904313.ospite@studenti.unina.it> <alpine.LNX.2.00.1010061130430.29535@pobox.suse.cz>
 <20101015094436.50ab68f3.ospite@studenti.unina.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, Antonio Ospite wrote:

> > > > > here are some fixes to hidraw.
> > > > > 
> > > > > Patches are against 2.6.36-rc6, but they should be ported to other
> > > > > maintained stable kernels as well.
> [...]
> > 
> > I have added the 'Cc:' markings now and applied both patches, thanks.
> > 
> 
> Jiri, these are not in 2.6.36-rc8, any chance we can make it for 2.6.36?

Hi Antonio,

yes, it is in my queue. I am currently a bit overloaded with other things, 
so as this is technically not a regression, it wasn't on very top of my 
list. Stil, will be pushing it to Linus soon.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

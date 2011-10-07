Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab1JGIBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:01:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab1JGIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:01:34 -0400
Date: Fri, 7 Oct 2011 10:01:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
In-Reply-To: <20111006200440.GB25681@redhat.com>
Message-ID: <alpine.LRH.2.00.1110070959470.14853@twin.jikos.cz>
References: <20111006190526.GA13883@redhat.com> <20111006194432.GA21642@kroah.com> <20111006195007.GA24900@redhat.com> <20111006195824.GA22033@kroah.com> <20111006200440.GB25681@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Oct 2011, Dave Jones wrote:

>  > > I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
>  > > Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?
>  > 
>  > We could do that in a "generic" way by setting a "in-tree" flag type
>  > thing for everything that is built from within the kernel build, and
>  > then taint if that flag is not found.
> 
> what stops an out of tree module from setting that flag ?

What stops virtualbox developers from renaming the module in every 
release? That's the same story.

The only fool-proof way of doing is indeed is the GPG-signing thing.

-- 
Jiri Kosina
SUSE Labs


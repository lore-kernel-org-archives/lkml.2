Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161360Ab2JXWAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:00:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935420Ab2JXWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:00:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Date: Thu, 25 Oct 2012 00:04:46 +0200
Message-ID: <1787395.7AzIesGUbB@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121024141303.0797d6a1.akpm@linux-foundation.org>
References: <20121012125708.GJ10110@dhcp22.suse.cz> <20121024210600.GA17037@liondog.tnic> <20121024141303.0797d6a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 of October 2012 14:13:03 Andrew Morton wrote:
> On Wed, 24 Oct 2012 23:06:00 +0200
> Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Wed, Oct 24, 2012 at 01:48:36PM -0700, Andrew Morton wrote:
> > > Well who knows. Could be that people's vm *does* suck. Or they have
> > > some particularly peculiar worklosd or requirement[*]. Or their VM
> > > *used* to suck, and the drop_caches is not really needed any more but
> > > it's there in vendor-provided code and they can't practically prevent
> > > it.
> > 
> > I have drop_caches in my suspend-to-disk script so that the hibernation
> > image is kept at minimum and suspend times are as small as possible.
> 
> hm, that sounds smart.
> 
> > Would that be a valid use-case?
> 
> I'd say so, unless we change the kernel to do that internally.  We do
> have the hibernation-specific shrink_all_memory() in the vmscan code. 
> We didn't see fit to document _why_ that exists, but IIRC it's there to
> create enough free memory for hibernation to be able to successfully
> complete, but no more.

That's correct.

> Who owns hibernaton nowadays?  Rafael, I guess?

I'm still maintaining it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

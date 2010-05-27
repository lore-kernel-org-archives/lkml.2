Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab0E0RV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:21:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:13238 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab0E0RVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:21:25 -0400
X-IronPort-AV: E=Sophos;i="4.53,312,1272844800"; 
   d="scan'208";a="127128"
Date: Thu, 27 May 2010 18:25:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Jackson <Ian.Jackson@eu.citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH 11/11] Unplug emulated disks and nics
In-Reply-To: <19454.34430.471499.222290@mariner.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1005271824220.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-11-git-send-email-stefano.stabellini@eu.citrix.com> <4BFC3390.4060503@goop.org> <alpine.DEB.2.00.1005261325110.25605@kaball-desktop> <4BFD8BB0.90301@goop.org>
 <m2n.s.1OHcBK-0018DA@chiark.greenend.org.uk> <19454.34430.471499.222290@mariner.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Ian Jackson wrote:
> Stefano Stabellini writes ("[Xen-devel] Re: [PATCH 11/11] Unplug emulated disks and nics"):
> > On Wed, 26 May 2010, Jeremy Fitzhardinge wrote:
> > > Wow, this interface is perverse.  It reuses the same IO port but changes
> > > function depending on the size of the IO?  Again, wow.
> >  
> > Yeah, before you ask, I didn't write it :)
> 
> Yes, neither did I :-).  However, I did document it and now I also
> maintain the "product number" registry.  Did you find the interface
> spec ?  Enclosed below in case not.
> 
> I hereby allocate you ("pvops PV-on-HVM Linux, upstream") product
> number 3.  Does the kernel have a way to distinguish between upstream
> and other versions ?  Eg, there's the kernel version name suffix
> thingy if I remember rightly.  Perhaps we should allocate a different
> number for "some pvops pv-on-hvm Linux with a nonempty kernel version
> name suffix".  Please advise.
> 
> You are welcome to use whatever you like for the "build number".
> Perhaps the best thing would a two-byte encoding of the kernel version
> number if that is possible.  As the purpose is logging and
> blacklisting, it's not that critical although it's better to reuse the
> same number for excessively similar builds than to use a random scheme
> which might generate accidental clashes between unrelated versions.
> 

It seems reasonable to me.
Jeremy, what do you think?


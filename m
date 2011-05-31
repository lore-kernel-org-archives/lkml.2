Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1EaMM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:12:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:35559 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab1EaMM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:12:28 -0400
Date: Tue, 31 May 2011 08:12:15 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531121215.GA4215@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>
References: <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
 <20110531075306.GB20798@elte.hu>
 <1306832148.2029.484.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306832148.2029.484.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:55:47AM +0100, David Woodhouse wrote:
> On Tue, 2011-05-31 at 09:53 +0200, Ingo Molnar wrote:
> > I'll always prefer typing:
> >   make ARCH=x86_64 ...
> > To:
> >   make ARCH=x86 CONFIG_64BIT=y ...
> 
> You're not building on an x86 box? I always suspected you had some alien
> technology! Does it run Linux?
> 
> Why else would you need to specify ARCH=x86 on the latter command line? 

I don't know why Ingo needs ARCH=x86 on the command line, but I
regularly type "make ARCH=i386" when building 32-bit kernels on a
64-bit system, and my scripts use "make ARCH=x86_64" when building
64-bit kernels (just in case I happen to have booted a 32-bit kernel).

       	       	     	       	      - Ted


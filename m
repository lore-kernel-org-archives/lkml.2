Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2I0RsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:48:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40888 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2I0RsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:48:03 -0400
Date: Thu, 27 Sep 2012 19:48:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Vas Dias <jason.vas.dias@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Comrade DOS <suloevdmitry@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: PROBLEM: Performance drop
Message-ID: <20120927174824.GD8759@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jason Vas Dias <jason.vas.dias@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
	Comrade DOS <suloevdmitry@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
 <20120524123116.GA4048@alberich.amd.com>
 <CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com>
 <20120529140940.GA10421@alberich.amd.com>
 <CA+fU7qdKYA3KJr3xET_evO_1ztSKh0K0csn5Coro7Mkv_my+eg@mail.gmail.com>
 <20120530124333.GA3008@alberich.amd.com>
 <CALyZvKxcdNWMHEGwgdO=sGTTs9sZYerYXcQEyqFwixKzzz3giA@mail.gmail.com>
 <20120711220643.GD10930@kroah.com>
 <CALyZvKwDoOPESJPHy5zBviVBuxT92eNGGCJrfd+XBdmya=uQEA@mail.gmail.com>
 <20120927173456.GA21025@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120927173456.GA21025@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:34:56AM -0700, Greg Kroah-Hartman wrote:
> On Sat, Jul 14, 2012 at 12:11:41PM +0100, Jason Vas Dias wrote:
> > Hi - any progress on this or on the patch I submitted for it ? -
> > please see enclosed - apologies for my being forced to use gmail which
> > has mandatory line wrap -
> > Please do something about restoring correct thermal operation on
> > x86_64 K8's with HP BIOS !
> > Thanks & Regards,
> > Jason
> > 
> > Re: [PATCH: 1/1] ACPI: make evaluation of thermal trip points before
> > temperature or vice versa dependant on new "temp_b4_trip" module
> > parameter to support older AMD x86_64s
> 
> I don't see this patch in Linus's tree, so I can't do anything about it
> in a stable kernel release.  Please work with the ACPI developers to get
> it pushed to Linus's tree, and after that, let me know what the git
> commit id is of it so I can add it to a stable release.

Yeah,

this patch adds a dmi quirk *and* a module parameter which looks kinda
too much to me. In any case, Andreas needs to look at this since he's
been dealing with those old laptops.

Jason, can you clean up your patch, drop the module parameter, write a
proper commit message, run it through checkpatch.pl and send it as a
reply to this thread with a mail client which doesn't mangle it so that
we can look at it further?

Thanks.

-- 
Regards/Gruss,
Boris.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab1I3LHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 07:07:55 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:43613 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab1I3LHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:07:53 -0400
X-SENDER-IP: [85.230.28.149]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArxXAI2ihU5V5hyVPGdsb2JhbABBiSyefBkBAQEBNzKBUwEBBTocEwEPEAgDGC4UJQoaE4d9txQOhjFhBJkPjAw
X-IronPort-AV: E=Sophos;i="4.68,466,1312149600"; 
   d="scan'208";a="487653766"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 30 Sep 2011 13:13:12 +0200
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        MikeWaychiso@bitmath.org
Subject: Re: [PATCH v3 10/10] x86, efi: EFI boot stub support
Message-ID: <20110930111312.GA6567@polaris.bitmath.org>
References: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
 <1316607036-9235-1-git-send-email-matt@console-pimps.org>
 <20110929101418.GA2215@polaris.bitmath.org>
 <1317368465.3375.6.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317368465.3375.6.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:41:05AM +0100, Matt Fleming wrote:
> On Thu, 2011-09-29 at 12:14 +0200, Henrik Rydberg wrote:
> > Using this version 3 of the patch, and a builtin commandline, I am
> > able to boot a MacBookAir3,1 directly into a blessed bzImage. The
> > screen comes up correctly.
> > 
> > Tested-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Great! Thanks for testing it out.
> 
> > As a side note, resume from suspend seems to leave the screen blank.
> 
> Hmm.. interesting. Presumably this only happens with these patches
> applied? i.e. if you remove the patches you don't see a blank screen on
> resume? I'll see if I can reproduce this on my macbook.

No, sorry, it never worked on this machine when booting from EFI.
AFAICT, there is no known way to control backlight either (nvidia
320M). If you have a similar setup, sharing findings would be most
interesting (off-line).

Thanks,
Henrik

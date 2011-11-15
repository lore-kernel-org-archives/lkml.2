Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1KOKbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:31:04 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:20016 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab1KOKbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:31:02 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADA+wk5R8itd/2dsb2JhbABDqWmBBoFyAQEEATocIxAIA0YUJQMhiBUCuwcSiQ9jBJQviH+IfQ
Date: Tue, 15 Nov 2011 11:28:03 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Paul Bolle <pebolle@tiscali.nl>, Richard Purdie <rpurdie@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: ARCH_PXA_ADX
Message-ID: <20111115102803.GC23376@infomag.iguana.be>
References: <1321351777.20271.166.camel@x61.thuisdomein> <20111115101817.GA6907@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115101817.GA6907@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> > 2) So it seems these two drivers could never have been built from the
> > mainline tree. (I'm starting to think that the config tools should
> > somehow check stuff like this.)
> > 
> > 3) Is the above correct? If it is, why shouldn't I submit the trivial
> > patch to remove both these drivers?
> 
> Yes, all of that is correct. Unfortunately, I never got around to mainlining
> the rest of the code. Feel free to remove both drivers and add my Acked-by.

I will remove the watchdog driver out of my trees and sent it to Linus.

Kind regards,
Wim.


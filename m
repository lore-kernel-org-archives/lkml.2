Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0IRAHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 20:07:08 -0400
Received: from foo.birdnet.se ([213.88.146.6]:34429 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750782Ab0IRAHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 20:07:07 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2010 20:07:06 EDT
Message-ID: <20100918000024.4334.qmail@stuge.se>
Date: Sat, 18 Sep 2010 02:00:23 +0200
From: Peter Stuge <peter@stuge.se>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux1394-devel@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] FireWire fixes
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel@lists.sourceforge.net,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <tkrat.b186ea3830d71c45@s5r6.in-berlin.de> <1284764773.2804.7.camel@maxim-laptop> <4C93FCC7.9040406@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C93FCC7.9040406@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> > Cable disconection/reconnection still results in the link loss till
> > ifconfig down/up.
> 
> Surely a higher-level problem somewhere in firewire-net.

How to deal with cable glitch? The cable might as well never be
attached again. A timeout? How long? There's a timeout also in SBP-2 IIRC?


//Peter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2JALjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 07:39:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55411 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab2JALj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 07:39:29 -0400
Date: Mon, 1 Oct 2012 12:39:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
Message-ID: <20121001113927.GJ4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
 <20121001100321.GB4360@opensource.wolfsonmicro.com>
 <1349086606.24442.13.camel@x61.thuisdomein>
 <20121001101859.GC4360@opensource.wolfsonmicro.com>
 <1349087577.24442.21.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349087577.24442.21.camel@x61.thuisdomein>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 12:32:57PM +0200, Paul Bolle wrote:
> On Mon, 2012-10-01 at 11:19 +0100, Mark Brown wrote:

> > I haven't actually stared hard enough at the code to figure this out
> > yet but given what you're changing I'd hope it's a flow analysis bug.
> > I'm certainly not seeing a warning here.

> Well, you may be using another version of gcc, or using different
> defaults. I'm using gcc-4.7.2-2.fc17.x86_64 (ie, the gcc currently
> shipped in Fedora 17 for x86_64), in what I think to be default
> settings.

Yes, of course.  Hence my comment about their flow analysis getting
worse and worse.

> Note that it's not some local oddity. Looking at the (currently) latest
> log for a Fedora build of v3.6-rc7 you'll find an identical warning [0].
> Apparently that build was done with gcc-4.7.1-5.fc18.x86_64 [1].

I assume this is a regression they've introduced in 4.7.

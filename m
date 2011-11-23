Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1KWQKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:10:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51794 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KWQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:10:30 -0500
Date: Wed, 23 Nov 2011 16:10:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
Message-ID: <20111123161012.GA31423@sirena.org.uk>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <4ECC67B9.4050306@codeaurora.org>
 <CAK=WgbYyrbZLmDOx8yKWwjhn2MYN8669FDRvsYZSyLj1equcTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbYyrbZLmDOx8yKWwjhn2MYN8669FDRvsYZSyLj1equcTw@mail.gmail.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:27:31PM +0200, Ohad Ben-Cohen wrote:
> On Wed, Nov 23, 2011 at 5:25 AM, Saravana Kannan <skannan@codeaurora.org> wrote:

> > Sorry for the rant, this naming just rubs me the wrong way. I definitely
> > appreciate the idea behind these patches.

> I don't share the same naming concerns you have (if any, then
> confusion with the bluetooth AMP patches and prefixes is more of a
> concern to me), but I don't care deeply about names.

I guess one very real potential for confusion here is the big/little
stuff that ARM are pushing for next generation SoCs where a Linux image
does actually run on muliple asymmetric cores.

> Feel free to offer a different name, though really 'amp' here only
> describes the general model and motivation and is rarely used
> throughout the code; we mostly either use 'remoteproc' or 'rpmsg',
> which respectively refer to the two frameworks that are being added
> (the former responsible for controlling the state of the remote
> processors, and the latter for communicating with them).

How about using remoteproc then?

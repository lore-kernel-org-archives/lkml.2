Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2EJLOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:14:16 -0400
Received: from trinity.fluff.org ([89.16.178.74]:39325 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2EJLOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:14:14 -0400
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 07:14:14 EDT
Date: Thu, 10 May 2012 11:43:11 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, Igor Grinberg <grinberg@compulab.co.il>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@ardb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Handling of modular boards
Message-ID: <20120510104311.GB30103@trinity.fluff.org>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <4FA432E9.9050606@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA432E9.9050606@wwwdotorg.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 01:50:01PM -0600, Stephen Warren wrote:
> On 05/04/2012 12:58 PM, Mark Brown wrote:
> > Quite a few reference platforms (including Wolfson ones, which is why
> > I'm particularly interested) use replaceable modules to allow
> > configuration changes.  Since we can often identify the configuration at
> > runtime we should ideally do that but currently there's no infrastructure 
> > to help with that...
> 
> So, I'll respond within the context of device tree, although perhaps you
> were looking for something more general?
> 
> I was just asked basically the same question internally to NVIDIA. One
> option that was floated was to store the device tree in chunks and have
> the bootloader piece them together. You'd start with the DT for the
> basic CPU board, probe what HW was available, and then graft in the
> content of additional DT chunks and pass the final result to the kernel.
> The advantages here are:
> 
> a) The DT is stored in chunks for each plugin board, so there's no bloat
> in the DT that gets passed to the kernel; it contains exactly what's on
> the board.

Interesting, but how does it sort ofu things like mapping GPIO lines from
the add-in board's view to the rest of the system?


-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.


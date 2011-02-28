Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1B1IES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:04:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46530 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1B1IER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:04:17 -0500
Date: Mon, 28 Feb 2011 01:04:14 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org, Rob Herring <robherring2@gmail.com>,
        linux-kernel@vger.kernel.org,
        Christian Krafft <parabelboi@bopserverein.de>
Subject: Re: [RFC PATCH] ipmi: convert OF driver to platform driver
Message-ID: <20110228080414.GB13690@angua.secretlab.ca>
References: <1298497079-20546-1-git-send-email-robherring2@gmail.com>
 <20110224031528.GB12139@angua.secretlab.ca>
 <201102241534.50886.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102241534.50886.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:34:50PM +0100, Arnd Bergmann wrote:
> On Thursday 24 February 2011, Grant Likely wrote:
> > On Wed, Feb 23, 2011 at 03:37:59PM -0600, Rob Herring wrote:
> > > From: Rob Herring <rob.herring@calxeda.com>
> > > 
> > > of_bus is deprecated in favor of the plain platform bus. This patch
> > > merges the ipmi OF driver with the existing platform driver.
> > > 
> > > CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
> > > 
> > > Compile tested with and without CONFIG_OF. Tested OF probe and
> > > default probe cases.
> > > 
> > > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > 
> > Wow.  That driver does some weird things with the driver model that
> > really should be cleaned up.  That said, this change looks correct.
> > I'll add it to my tree and see how it goes.
> 
> Please keep me in the look when you want to do further into cleaning
> this up. The OF code was initially done for the QS21 running SLOF, and
> predates the flattened device tree specs.

Will do.  I've got no plans to fiddle with this code beyond getting
rid of the of_platform_driver abstractions, but I'll keep my eye out
for changes that you should be cc'd on.

g.


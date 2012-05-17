Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2EQPGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:06:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41105 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab2EQPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:06:06 -0400
Date: Thu, 17 May 2012 08:06:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, sfr@canb.auug.org.au,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, maxime.ripard@free-electrons.com,
        olof@lixom.net, linux-next@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: Add ADC driver to at91sam9260/at91sam9g20
 dtsi files
Message-ID: <20120517150601.GA28104@kroah.com>
References: <4FB3B1F3.6080102@atmel.com>
 <1337182626-13033-1-git-send-email-nicolas.ferre@atmel.com>
 <201205161850.54765.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205161850.54765.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 06:50:54PM +0000, Arnd Bergmann wrote:
> On Wednesday 16 May 2012, Nicolas Ferre wrote:
> > Now that the bulk of at91sam9g20-related nodes are located in at91sam9260.dtsi,
> > we have to re-create the path to this ADC node for SoC specific parts.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Should we apply this patch in arm-soc so that Greg can drop the hunk that
> no longer applies?

It's not a "no longer applies", it's a "this does not merge".  The patch
is in my tree, unless you want me to revert it, it's going to stay there
until it goes to Linus.

thanks,

greg k-h

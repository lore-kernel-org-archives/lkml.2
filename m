Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1DENql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:46:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34191 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1DENqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:46:40 -0400
Date: Tue, 5 Apr 2011 07:46:35 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-mmc@vger.kernel.org, Daniel Ribeiro <drwyrm@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Chris Ball <cjb@laptop.org>, Ernst Schwab <eschwab@online.de>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        openezx-devel@lists.openezx.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mmc_spi: Add support for regulator framework
Message-ID: <20110405134635.GA30849@ponder.secretlab.ca>
References: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
 <20110404115631.67b1f317.ospite@studenti.unina.it>
 <20110405030543.GC29522@ponder.secretlab.ca>
 <20110405104347.0f93ab97.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405104347.0f93ab97.ospite@studenti.unina.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 10:43:47AM +0200, Antonio Ospite wrote:
> On Mon, 4 Apr 2011 21:05:43 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > On Mon, Apr 04, 2011 at 11:56:31AM +0200, Antonio Ospite wrote:
> > > On Mon, 21 Mar 2011 19:46:38 +0100
> > > Antonio Ospite <ospite@studenti.unina.it> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > this patchset has the purpose of adding support for the regulator framework to 
> > > > the mmc_spi driver. The first three patches are preparatory cleanups to make 
> > > > the fourth one more straightforward.
> > > > 
> > > > Maybe the fourth patch can be improved, I am open to any suggestions about it.
> > > >
> > > 
> > > Ping. I forgot to Cc spi-devel-general on this series, should I resend
> > > it?
> > 
> > Not a bad idea.  It doesn't go via my tree since it is an mmc patch,
> > not an spi one, but I don't mind taking a look at the spi bits.
> > 
> 
> Grant you were on Cc from the start so you should have the patches
> somewhere; please tell me if you don't.
> I'd avoid resending if not strictly necessary.

Ah, then I probably scanned it briefly and decided I didn't need to
respond to it.  Don't worry about reposting.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1JMDbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 23:31:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53283 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1JMDbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 23:31:14 -0400
Date: Wed, 12 Oct 2011 21:31:10 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20111013033110.GB15829@ponder.secretlab.ca>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110829221132.GB26846@sirena.org.uk>
 <4E5C76E0.4000008@zytor.com>
 <20110830110020.GE2061@opensource.wolfsonmicro.com>
 <20110830104955.4b1b8381@v0nbox>
 <CACRpkdYmZc6H6iNp6n8qUizUAHQxNbr32gjtxYe7LSb-bq=Kew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYmZc6H6iNp6n8qUizUAHQxNbr32gjtxYe7LSb-bq=Kew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:41:00PM +0200, Linus Walleij wrote:
> On Tue, Aug 30, 2011 at 4:49 PM, Vivien Didelot
> <vivien.didelot@savoirfairelinux.com> wrote:
> 
> > Grouping every driver for this platform was one of the main comments of
> > my first RFC set of patches. And indeed, the GPIO driver is really
> > specific to this platform, so it won't be shared.
> 
> What we've seen is that it's no fun for the arch/platform maintainer
> when GPIO drivers start to proliferate the arch.
> 
> You should have Grants Likelys ACK on this no matter where it
> ends up anyway so let's hear what he says?
> 
> Yours,
> Linus Walleij

I never saw this patch.  Please cc me on gpio changes.

g.


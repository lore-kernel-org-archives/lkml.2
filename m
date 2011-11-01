Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1KASvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:51:40 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49906 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab1KASvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:51:38 -0400
X-Sasl-enc: Y9eABs9O9HuJ2aBAzVJ5hY2fiThrGEiq1uuqPSabGaRa 1320173498
Date: Tue, 1 Nov 2011 11:47:11 -0700
From: Greg KH <greg@kroah.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>,
        Koji Matsumuro <matsumur@nts.ricoh.co.jp>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Always check for lower base frequency quirk for
 Ricoh 1180:e823
Message-ID: <20111101184711.GA13637@kroah.com>
References: <20111005154449.GA2479@zod.bos.redhat.com>
 <20111014090727.2ad3d774@jbarnes-desktop>
 <20111014162429.GF1165@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014162429.GF1165@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 12:24:37PM -0400, Josh Boyer wrote:
> On Fri, Oct 14, 2011 at 09:07:27AM -0700, Jesse Barnes wrote:
> > On Wed, 5 Oct 2011 11:44:50 -0400
> > Josh Boyer <jwboyer@redhat.com> wrote:
> > 
> > > Commit 15bed0f2f added a quirk for the e823 Ricoh card reader to lower the
> > > base frequency.  However, the quirk first checks to see if the proprietary
> > > MMC controller is disabled, and returns if so.  On some devices, such as the
> > > Lenovo X220, the MMC controller is already disabled by firmware it seems,
> > > but the frequency change is still needed so sdhci-pci can talk to the cards.
> > > Since the MMC controller is disabled, the frequency fixup was never being run
> > > on these machines.
> > > 
> > > This moves the e823 check above the MMC controller check so that it always
> > > gets run.
> > > 
> > > This fixes https://bugzilla.redhat.com/show_bug.cgi?id=722509
> > > 
> > 
> > Applied to linux-next, thanks.  I forgot to cc stable on it though;
> > once it hits Linus's tree you may want to make sure it gets backported
> > to 3.0.x and 3.1.x.
> 
> OK.  Will do.  Thanks Jesse.

I've queued it up now, no need for you to remind me.

greg k-h

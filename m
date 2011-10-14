Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1JNQYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:24:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab1JNQYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:24:47 -0400
Date: Fri, 14 Oct 2011 12:24:37 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>,
        Koji Matsumuro <matsumur@nts.ricoh.co.jp>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Always check for lower base frequency quirk for
 Ricoh 1180:e823
Message-ID: <20111014162429.GF1165@zod.bos.redhat.com>
References: <20111005154449.GA2479@zod.bos.redhat.com>
 <20111014090727.2ad3d774@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014090727.2ad3d774@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:07:27AM -0700, Jesse Barnes wrote:
> On Wed, 5 Oct 2011 11:44:50 -0400
> Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > Commit 15bed0f2f added a quirk for the e823 Ricoh card reader to lower the
> > base frequency.  However, the quirk first checks to see if the proprietary
> > MMC controller is disabled, and returns if so.  On some devices, such as the
> > Lenovo X220, the MMC controller is already disabled by firmware it seems,
> > but the frequency change is still needed so sdhci-pci can talk to the cards.
> > Since the MMC controller is disabled, the frequency fixup was never being run
> > on these machines.
> > 
> > This moves the e823 check above the MMC controller check so that it always
> > gets run.
> > 
> > This fixes https://bugzilla.redhat.com/show_bug.cgi?id=722509
> > 
> 
> Applied to linux-next, thanks.  I forgot to cc stable on it though;
> once it hits Linus's tree you may want to make sure it gets backported
> to 3.0.x and 3.1.x.

OK.  Will do.  Thanks Jesse.

josh

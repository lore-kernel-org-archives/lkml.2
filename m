Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab1FGTIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:08:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50689 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab1FGTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qrPTJhGptDB0FpEcB3HyqbaON2fl9uBujpcGEnQljGJngddNq8a6Abd1k7kL6eXKqt
         XD8K9XwxLlZ1qQIv7nWMJci0RUe687LwO3ggKQjjV+DLUWiKHuCdPXYwKuFbNhpMweaE
         3ZR1bYKWlOLTXBWMjSAobF5Xp64fnTD9DONXA=
Date: Tue, 7 Jun 2011 22:06:07 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        rmallon@gmail.com, vinod.koul@intel.com, dan.j.williams@intel.com,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] spi/ep93xx: add DMA support
Message-ID: <20110607190607.GB3011@acer>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <4b27fc93b7df900943e7c12084a8340cbc5fe1a8.1306662317.git.mika.westerberg@iki.fi>
 <20110603204400.GH17972@ponder.secretlab.ca>
 <20110607171403.GA3011@acer>
 <BANLkTikKOcc2Vg1p3kG4ZSLjJ0RTZWS=2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikKOcc2Vg1p3kG4ZSLjJ0RTZWS=2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 12:45:26PM -0600, Grant Likely wrote:
> On Tue, Jun 7, 2011 at 11:14 AM, Mika Westerberg <mika.westerberg@iki.fi> wrote:
> >
> > I just realized that once the SPI driver renaming patch (spi: reorganize
> > drivers) enters linux-next, this patch (which sits on Vinod's tree) will cause
> > a merge conflict. Any ideas how to avoid it beforehand?
> 
> Yes, put the whole series into a separate branch all by itself.  Merge
> that branch into Vinod's tree and I'll also merge it into spi/next,
> and I'll fix up the merge conflict when I do.

More stupid questions: Do you mean that I create a branch in my public
repository somewhere? If that is the case, then there is a problem that I
don't have any public repository and I doubt that I get such before linux-next
is rebuilt.

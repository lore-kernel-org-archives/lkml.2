Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab1JGMir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:38:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49812 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498Ab1JGMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:38:45 -0400
Date: Fri, 7 Oct 2011 13:38:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Temporary relocation of the regulator tree
Message-ID: <20111007123842.GF14518@opensource.wolfsonmicro.com>
References: <20111007114046.GA24534@sirena.org.uk>
 <20111007233607.dfaf5622a5001c594163d41f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007233607.dfaf5622a5001c594163d41f@canb.auug.org.au>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 11:36:07PM +1100, Stephen Rothwell wrote:
> On Fri, 7 Oct 2011 12:40:46 +0100 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > Due to a combination of the kernel.org downtime and an intensely busy
> > time at work for Liam can you please change the regulator tree in -next
> > to be:

> > 	git://opensource.wolfsonmicro.com/regulator.git for-next

> > until Liam manages to get sufficient free time to keep up with the day
> > to day flow again.

> OK, I will switch to that tree from Tuesday (Monday is a holiday) unless
> Liam screams.  I have also added you as a contact for this tree (called
> voltage in linux-next - would it be better to call it regulator?).

It should be called regulator, the code is all called regulator.  I
never understood why you'd labelled it voltage :)

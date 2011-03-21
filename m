Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab1CUX3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:29:52 -0400
Received: from trinity.fluff.org ([89.16.178.74]:55444 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240Ab1CUXRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:53 -0400
Date: Mon, 21 Mar 2011 23:17:39 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Belisko Marek <marek.belisko@gmail.com>, alsa-devel@alsa-project.org,
        tiwai@suse.de, linux-kernel@vger.kernel.org, perex@perex.cz,
        ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org,
        lrg@slimlogic.co.uk
Subject: Re: [PATCH RFC] arm: mini2440: Fix uda134x codec problem.
Message-ID: <20110321231739.GE9995@trinity.fluff.org>
References: <1299703580-3957-1-git-send-email-marek.belisko@open-nandra.com> <20110311121704.GF1760@opensource.wolfsonmicro.com> <AANLkTintYQ=qO3PALBL-bkiYKQFw0+JiW3=-oZmkRhZ1@mail.gmail.com> <20110311122637.GH1760@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311122637.GH1760@opensource.wolfsonmicro.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 12:26:37PM +0000, Mark Brown wrote:
> On Fri, Mar 11, 2011 at 01:23:37PM +0100, Belisko Marek wrote:
> 
> > You're right. I think sending whole patch to help understand what
> > I'm trying to do (because wasn't sure). You apply just asoc part right?
> > Thanks for comments!
> 
> I applied everything, Ben has said he is very busy so it seemed easiest
> to just merge the whole thing.

That's fine, and as long as it doesn't mess up other merges I'm generally
ok with this.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.


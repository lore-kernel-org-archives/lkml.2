Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1AMVXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:23:14 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:25984 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1AMVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:23:09 -0500
Date: Thu, 13 Jan 2011 22:22:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.38
Message-ID: <20110113222258.128d6a13@endymion.delvare>
In-Reply-To: <20110111112458.GA13429@opensource.wolfsonmicro.com>
References: <20110110222145.31c40d8e@endymion.delvare>
	<20110111111758.GH6541@sirena.org.uk>
	<20110111122500.203c4ce4@endymion.delvare>
	<20110111112458.GA13429@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 11:24:59 +0000, Mark Brown wrote:
> On Tue, Jan 11, 2011 at 12:25:00PM +0100, Jean Delvare wrote:
> 
> > Thanks for the reminder, I'll look into that as soon as possible and
> > when the patches are ready, I'll send another pull request to Linus.
> 
> Excellent, thanks - I was worried it might've got lost since you were on
> vacation during pretty much all of the discussion.

Correct, but I trust that you and Rafael got things right. I don't know
much about power management anyway.

So I've applied two patches from you. Please check in:
  ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
that I picked the correct versions and confirm that nothing is missing.
If everything looks OK to you, I'll send a pull request to Linus
tomorrow.

-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1AMXYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:24:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57314 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756943Ab1AMXYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:24:13 -0500
Date: Thu, 13 Jan 2011 23:24:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.38
Message-ID: <20110113232428.GB13717@opensource.wolfsonmicro.com>
References: <20110110222145.31c40d8e@endymion.delvare>
 <20110111111758.GH6541@sirena.org.uk>
 <20110111122500.203c4ce4@endymion.delvare>
 <20110111112458.GA13429@opensource.wolfsonmicro.com>
 <20110113222258.128d6a13@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113222258.128d6a13@endymion.delvare>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 10:22:58PM +0100, Jean Delvare wrote:

> So I've applied two patches from you. Please check in:
>   ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/

> that I picked the correct versions and confirm that nothing is missing.
> If everything looks OK to you, I'll send a pull request to Linus
> tomorrow.

Looks like that's everything, yes - the PM bits that the factoring out
patch depended on are already in Linus' tree.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0FCMDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:03:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48171 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750969Ab0FCMDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:03:53 -0400
Date: Thu, 3 Jun 2010 13:03:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [RFC][PATCH 20/26] alsa: ASoC: Add JZ4740 codec
 driver
Message-ID: <20100603120350.GC2762@rakim.wolfsonmicro.main>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
 <1275505950-17334-4-git-send-email-lars@metafoo.de>
 <4C074171.2080106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C074171.2080106@gmail.com>
X-Cookie: In the next world, you're on your own.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:45:21PM +0800, Wan ZongShun wrote:

> Your all the patches have two kinds of 'WARNING:',as following:

> (1)'WARNING: line over 80 characters' and

> Please make a line less than 80 characters.

You need to apply a certain degree of taste when looking at checkpatch
warnings, particularly things like line length.  Sometimes fixing the
warning for the sake of fixing the warning makes the code uglier than it
would be with whatever the style issue that's been identified is.

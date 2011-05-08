Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1EHQGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 12:06:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52713 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754327Ab1EHQGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 12:06:00 -0400
Date: Sun, 8 May 2011 17:06:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] soc: fix wm8958-dsp2 printk format warnings
Message-ID: <20110508160604.GB32214@opensource.wolfsonmicro.com>
References: <20110505134959.b3761297.sfr@canb.auug.org.au>
 <20110506161310.54b22b9f.randy.dunlap@oracle.com>
 <20110508140101.GB15968@opensource.wolfsonmicro.com>
 <4DC6B8F7.4000302@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC6B8F7.4000302@oracle.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 08:38:31AM -0700, Randy Dunlap wrote:

> Do I need to resend the patch?

Please, it'll need to at least go by Liam as well (this was the bit
about making sure you send patches to maintainers).

> What subsystem prefix do you want to see there?  from MAINTAINERS file:
> SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)

The same as all the other commits in the subsystem - ASoC.  MAINTAINERS
won't tell you how subsystems format their commit logs, there's a few
different conventions floating around (eg, [SCSI] is unusual, and some
subsystems just have the driver name).

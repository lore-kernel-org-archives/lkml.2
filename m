Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0HYNV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:21:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50185 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752685Ab0HYNVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:21:55 -0400
Date: Wed, 25 Aug 2010 14:22:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] ASoC: pxa-ssp: fix a memory leak in pxa_ssp_remove()
Message-ID: <20100825132212.GB1102@opensource.wolfsonmicro.com>
References: <1282726751.5051.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282726751.5051.4.camel@mola>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 04:59:11PM +0800, Axel Lin wrote:
> The "priv" allocated in pxa_ssp_probe() should be kfreed in pxa_ssp_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

This doesn't apply against current ASoC.  I fixed this up by hand since
the error was so trivial but in future could you please make sure you
generate your code against the latest version of ASoC?  This will be in
-next at any given time, or for the individual tree you want the latest
for-2.6.nn branch of:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git

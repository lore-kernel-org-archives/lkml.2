Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0C1Joj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 05:44:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41875 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0C1Joi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 05:44:38 -0400
Date: Sun, 28 Mar 2010 10:44:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       Wolfram Sang <w.sang@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in
	soc_common.c
Message-ID: <20100328094408.GA23048@n2100.arm.linux.org.uk>
References: <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1269474310-13970-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <20100325170440.GC5424@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325170440.GC5424@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 06:04:40PM +0100, Dominik Brodowski wrote:
> do you prefer me pushing these patches upstream (possibly even for -rc3), or
> do you wish to take these patches?

I'll take them through the patch system, but as they're not bug fixes
I'd queue them for the next merge window.

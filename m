Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0KXP46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:56:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53992 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752885Ab0KXP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:56:58 -0500
Date: Wed, 24 Nov 2010 15:56:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: Raise default NR_IRQS when using sparse
 IRQs
Message-ID: <20101124155656.GK24970@rakim.wolfsonmicro.main>
References: <1290613156-861-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.1011241642540.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011241642540.2900@localhost6.localdomain6>
X-Cookie: Made with real ingredients.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 04:45:03PM +0100, Thomas Gleixner wrote:

> Resulting in a 256 MB bitmap. I guess you did not try to boot that on
> some random ARM board :)

Right, I don't actually have any platforms that support sparse IRQs.  Ho
hum.  I guess something like 16k or 4k IRQs might be more sane.

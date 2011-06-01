Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163317Ab1FAIaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:30:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33012 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163213Ab1FAIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:30:20 -0400
Date: Wed, 1 Jun 2011 09:30:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
Message-ID: <20110601083000.GD3660@n2100.arm.linux.org.uk>
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com> <alpine.LFD.2.02.1105311236250.3078@ionos> <4DE51EB7.7010606@stericsson.com> <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:18:25PM +0200, Linus Walleij wrote:
> Keeping it under include/linux is probably wise since we want drivers
> OUT of the ARM tree, but I don't know if there is much consensus on that?

Header files private to a driver should be alongside the driver.  Look
at drivers/net or drivers/scsi for plenty of examples.

Just because its a header file does not mean it must be in some directory
with 'include' in its path.  The only reason to put it in include/linux
is if it contains stuff which needs to be shared outside of the driver
(eg, with arches).

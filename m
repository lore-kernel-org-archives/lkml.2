Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0HPVGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:06:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab0HPVGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:06:46 -0400
Date: Mon, 16 Aug 2010 22:06:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] cyber2000fb: avoid palette corruption at higher
	clocks
Message-ID: <20100816210634.GB10119@n2100.arm.linux.org.uk>
References: <201008162209.56902.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008162209.56902.linux@rainbow-software.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:09:54PM +0200, Ondrej Zary wrote:
> When 1280x1024@75Hz mode is set, console palette is not set properly -
> sometimes the background is white, sometimes yellow and text colors are also
> messed up. This does not happen at 1280x1024@60Hz and below.

I'm not going to have much time to look at your patches, and I
definitely want to test them on the NetWinder to make sure we
don't regress the primary platform that this driver is supporting.

I should have more time to look at them in September.

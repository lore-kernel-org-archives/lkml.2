Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0IUWYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:24:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52982 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0IUWYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=COVi9LXN/2yh0fpH29VMa23Tue+cGvvrUY+NSgmqY0TR7/pmjsbxPsYf6V+q4/SwHk
         dF07x465+BYO0TWGtj98j1x1tfz1uySWxxzBU2YGTPeRli2H1h5GB/48NHFi+5SRmYY/
         YBbcHrZ93PxL30eihQC3PEyiQzpfqucmT5Mgs=
Date: Wed, 22 Sep 2010 02:23:54 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Brownell <david-b@pacbell.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] gpio: Add driver for basic memory-mapped GPIO
 controllers
Message-ID: <20100921222354.GA337@oksana.dev.rtsoft.ru>
References: <20100831175839.GA32468@oksana.dev.rtsoft.ru>
 <755774.85376.qm@web180301.mail.gq1.yahoo.com>
 <20100907140132.GA31782@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100907140132.GA31782@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 06:01:32PM +0400, Anton Vorontsov wrote:
> The basic GPIO controllers may be found in various on-board FPGA
> and ASIC solutions that are used to control board's switches, LEDs,
> chip-selects, Ethernet/USB PHY power, etc.
> 
> These controllers may not provide any means of pin setup
> (in/out/open drain).
> 
> The driver supports:
> - 8/16/32/64 bits registers;
> - GPIO controllers with clear/set registers;
> - GPIO controllers with a single "data" register;
> - Big endian bits/GPIOs ordering (mostly used on PowerPC).
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> A lucky v7.
> 
> In v7 I only changed platform data handling. It appears that
> when used with MFD core, we can't just pass integers via
> platform_data poiner, as platform_device_add_data() would try
> to copy the data pointed by mfd_cell.platform_data.
> 
> This is now fixed by introducing a proper platform data
> struct.

Ping? Anyone?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

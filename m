Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2IEDvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:51:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34836 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2IEDvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:51:06 -0400
Date: Wed, 5 Sep 2012 11:51:10 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Subodh Nijsure <snijsure@grid-net.com>
Cc: paulmck@linux.vnet.ibm.com, linux-mtd@lists.infradead.org,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: RCU warning during UBI file system mount
Message-ID: <20120905035108.GV2362@S2101-09.ap.freescale.net>
References: <5042EC5D.1010207@grid-net.com>
 <1346744796.12610.6.camel@sauron.fi.intel.com>
 <20120904144813.GC2593@linux.vnet.ibm.com>
 <50462190.7090702@grid-net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50462190.7090702@grid-net.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 08:43:12AM -0700, Subodh Nijsure wrote:
> MX28 is ARM device. I removed following from my config and these
> warnings went away.
> 
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> 
There is no cpuidle implemented on imx28.  I do not understand how
these options influence the result here.

> I have attached the kernel configuration file I used.
> 
> It doesn't affect specific hw I am working with as device is not
> required to enter idle mode.
> I am Cc-ing linux-arm folks,  in case someone on arm platform
> requires CPU idele &, RCU to work.
> 
I just ran a case with CONFIG_CPU_IDLE and RCU support and failed
to reproduce the warning.  Is this something specific to gpmi-nand
or we can see it with any other imx28 drivers/cases?  Sorry, I do
not have NAND flash set up on my imx28 board.

-- 
Regards,
Shawn

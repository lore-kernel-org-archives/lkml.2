Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1CKQx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:53:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40726 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893Ab1CKQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:53:28 -0500
Date: Fri, 11 Mar 2011 16:53:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: andy.green@linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311165325.GU1760@opensource.wolfsonmicro.com>
References: <4D7A4D52.6010501@linaro.org>
 <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:45:20AM -0500, Alan Stern wrote:

> Or to put it another way...  With external, hot-plugged USB devices,
> there is no need to know "how it is wired".  The fact that it is on a 
> USB bus is the only information necessary.  Why does anyone need to
> know more than this for on-board USB devices?

Examples I'm aware of include things like power control beyond what the
USB spec does and not programming device identification or configuration
information that would normally be initialised by the hardware, relying
on the AP to program it at runtime.

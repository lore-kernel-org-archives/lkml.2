Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2CPSsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:48:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:59213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab2CPSsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:48:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="118436378"
Date: Fri, 16 Mar 2012 19:56:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-input@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH v3 2/2] input: add driver support for MAX8997-haptic
Message-ID: <20120316185626.GO20524@sortiz-mobl>
References: <4F5DB459.9090701@samsung.com>
 <20120314084652.GC3964@core.coreip.homeip.net>
 <4F60AF8E.7050900@samsung.com>
 <20120314154828.GA24964@core.coreip.homeip.net>
 <20120316174802.GI20524@sortiz-mobl>
 <20120316175524.GA19275@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316175524.GA19275@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, Mar 16, 2012 at 10:55:24AM -0700, Dmitry Torokhov wrote:
> > > OK, excellent. I'll pick up this fix and apply the driver for 3.4 queue,
> > > thanks!
> > Your patch depends on the MFD changes Choi sent along the input driver. I
> > think it would make more sense for me to take it. What do you think ?
> 
> I think that splitting required platform data definitions from the
> driver into separate patch is quite pointless. 
Hmm, you're right on this one.

> I often see a driver
> split in 3+ patches - headers, the driver itself and Kconfig/makefile
> changes and I wonder what made them do it...
> 
> Anyway, below is the consolidated patch I was going to apply to my tree,
> but if you want to go through yours - feel free to apply it.
No, I think it makes sense for you to take it. Add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

if you feel it's needed.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

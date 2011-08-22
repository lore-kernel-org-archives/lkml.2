Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab1HVNxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:53:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:12888 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1HVNxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:53:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,263,1312182000"; 
   d="scan'208";a="43831941"
Date: Mon, 22 Aug 2011 15:55:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Kyle Manna <kyle@kylemanna.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Keerthy <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Fixes to twl4030-madc and add BeagleBoard support
Message-ID: <20110822135530.GR4607@sortiz-mobl>
References: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
 <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

On Thu, Aug 11, 2011 at 10:33:11PM -0500, Kyle Manna wrote:
> These patches add basic functionality to the twl4030-madc driver to make
> it work on the BeagleBoard xM.
> 
> Version 2 adds fixes per Grazvydas Ignotas and the check for NULL pointer patch.
> 
> Kyle Manna (4):
>   mfd: twl4030-madc: copy the device pointer
>   mfd: twl4030-madc: turn on the MADC clock
>   mfd: twl4030-madc: check for NULL pointer
>   arm: BeagleBoard: add support for the twl4030-madc
Tony, are you ok with the BeagleBoard changes ?
The MFD ones look fine to me, I'd like to apply them.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

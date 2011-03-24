Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1CXLqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:46:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:42018 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab1CXLqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:46:00 -0400
Message-Id: <1bdc18$jvuest@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,236,1299484800"; 
   d="scan'208";a="671038365"
Date: Thu, 24 Mar 2011 11:45:57 +0000
To: Alessandro Suardi <alessandro.suardi@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: regression: GM45 on Dell Latitude E6400 display from 1440x900 to 1024x768 somewhere between 2.6.38-git2 and -git7
References: <AANLkTimxnG56Q29CpKi7q0kiam2cDKHdB5OjV-vu4he9@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTimxnG56Q29CpKi7q0kiam2cDKHdB5OjV-vu4he9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 12:30:49 +0100, Alessandro Suardi <alessandro.suardi@gmail.com> wrote:
> Fedora 14 x86_64
> 
> [   375.231] (II) intel(0): Integrated Graphics Chipset: Intel(R) GM45
> [   375.231] (--) intel(0): Chipset: "GM45"
> 
> startx yields:
> 
>  2.6.38-git2 and earlier: correct 1440x900 display
>  2.6.38-git3 through -git6: not tested due to kernel build errors
>  2.6.38-git7 through -git14: wrong 1024x768 display with black bands at sides
> 
> Once in wrong mode, xrandr --fb 1440x900 --output LVDS1 --mode 1440x900
>  helps return the screen to correct display, but:
> 
>  - background image is drawn incorrectly (like a 1440x900 correct one with a
>     superimposed 1024x768 starting from upper left corner)
>  - mplayer in full screen mode does not actually go full screen, but 1024x768
> 
> comparative Xorg logs and dmesg output for 2.6.38-git2 and -git14 available
>  upon request; lspci -v says:

There's not much we can say until we see those...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

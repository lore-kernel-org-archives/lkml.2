Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964882Ab2HWRUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:20:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:4616 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933866Ab2HWRUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:20:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="213059293"
Date: Thu, 23 Aug 2012 19:18:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Peter Tyser <ptyser@xes-inc.com>, Wim Van Sebroeck <wim@iguana.be>,
        Aaron Sierra <asierra@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        Tobias Powalowski <tpowa@archlinux.org>
Subject: Re: Serious regression in 3.5's iTCO_wdt, does anyone care?
Message-ID: <20120823171815.GE9889@sortiz-mobl>
References: <50363B12.4060009@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50363B12.4060009@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thu, Aug 23, 2012 at 04:15:46PM +0200, Thomas Bächler wrote:
> This regards the following commit in the Linus tree:
> 
> commit 887c8ec7219fc8eba78bb8f44a74c660934e9b98
> Author: Aaron Sierra <asierra@xes-inc.com>
> Date:   Fri Apr 20 14:14:11 2012 -0500
> 
>     watchdog: Convert iTCO_wdt driver to mfd model
> 
> Ever since the Linux 3.5 update, the iTCO_wdt driver has been completely
> non-functional on every machine I encountered due to the above
> conversion. A bug report for this problem has been open at
> https://bugzilla.kernel.org/show_bug.cgi?id=44991 for over a month.
Cc'ing the relevant maintainers usually helps...


> Yet, neither the author of the commit, nor the people who signed off on
> it have reacted to the bug report.
> 
> At this point, I believe that none of you are actually aware of the
> problem and I write you to change that unfortunate situation.
I applied Feng's patch to my for-linus branch and I'll send a pull request
soon. It should be part of the 3.6 kernel.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

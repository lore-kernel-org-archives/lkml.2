Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2GJQnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:43:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:47941 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab2GJQns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166346969"
Date: Tue, 10 Jul 2012 18:55:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 1/1] mfd: ab8500: Clean-up the last two ab8500 related DT
 match tables
Message-ID: <20120710165518.GG15345@sortiz-mobl>
References: <1341578598-9307-1-git-send-email-lee.jones@linaro.org>
 <20120710091304.GU15345@sortiz-mobl>
 <4FFC4A23.5000107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFC4A23.5000107@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jul 10, 2012 at 05:28:35PM +0200, Lee Jones wrote:
> On 10/07/12 11:13, Samuel Ortiz wrote:
> >Hi Lee,
> >
> >On Fri, Jul 06, 2012 at 01:43:18PM +0100, Lee Jones wrote:
> >>A patch was recently submitted to stop all ab8500 devices from
> >>being registered through Device Tree. Instead, only the db8500
> >>will be DT:ed and the rest will continue to be registered via
> >>the MFD API, as they always were.
> >>
> >>Two patches have recently been applied which enable Device Tree
> >>probing; one for rtc-ab8500 and the other for ponkey-ab8500.
> >>These two need to be removed to prevent double-probing these
> >>devices with Device Tree is enabled.
> >>
> >>Cc: Samuel Ortiz <sameo@linux.intel.com>
> >>Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>---
> >>  drivers/input/misc/ab8500-ponkey.c |    8 --------
> >>  drivers/rtc/rtc-ab8500.c           |    6 ------
> >>  2 files changed, 14 deletions(-)
> >I don't know against which tree you generated those patches, but none of those
> >2 of_device_id arrays are in my for-next branch. So I can't apply this patch.
> 
> I can rebase them on anything of your choosing.
> 
> What is your for-next branch based on?
On Linus' tree. And the of_device_id arrays are not there.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

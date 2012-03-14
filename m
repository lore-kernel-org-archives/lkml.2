Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2CNPsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:48:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60592 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2CNPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:48:35 -0400
Date: Wed, 14 Mar 2012 08:48:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-input@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH v3 2/2] input: add driver support for MAX8997-haptic
Message-ID: <20120314154828.GA24964@core.coreip.homeip.net>
References: <4F5DB459.9090701@samsung.com>
 <20120314084652.GC3964@core.coreip.homeip.net>
 <4F60AF8E.7050900@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F60AF8E.7050900@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:47:42PM +0900, Chanwoo Choi wrote:
> Hi Dmitry,
> 
> > This is not proper locking between playing effect and suspend. Now that
> > you are using workqueue you need to synchronize access with it, not with
> > play_effect method.
> > 
> > Does the following patch work for you?
> > 
> 
> Your patch is worked on TRATS board based on EXYNOS4210 but, you should
> apply following patch because 'chip->enabled' is used on
> max8997_haptic_configure() function to enable/disable haptic motor.

OK, excellent. I'll pick up this fix and apply the driver for 3.4 queue,
thanks!

-- 
Dmitry

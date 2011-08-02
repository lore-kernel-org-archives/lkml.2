Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1HBF0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 01:26:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49144 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1HBF02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 01:26:28 -0400
Date: Mon, 1 Aug 2011 22:26:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Anirudh Ghayal <aghayal@codeaurora.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Amy Maloche <amaloche@codeaurora.org>
Subject: Re: [PATCH] input: misc: Add support for pm8xxx based vibrator driver
Message-ID: <20110802052622.GB7372@core.coreip.homeip.net>
References: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org>
 <4E378043.3080801@cn.fujitsu.com>
 <20110802051156.GA7372@core.coreip.homeip.net>
 <4E3788B6.4020104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3788B6.4020104@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 01:18:46PM +0800, Wanlong Gao wrote:
> On 08/02/2011 01:11 PM, Dmitry Torokhov wrote:
> >On Tue, Aug 02, 2011 at 12:42:43PM +0800, Wanlong Gao wrote:
> >>On 08/02/2011 12:13 PM, Anirudh Ghayal wrote:
> >>>+/*
> >>>+ * struct pm8xxx_vib - structure to hold vibrator data
> >>>+ * @vib_input_dev: input device supporting force feedback
> >>>+ * @vwork: work structure to set the vibration parameters
> >>Anirudh,  It's should be @work?
> >
> >Looks like it, I can fix it up locally, no need to resubmit.
> >
> >BTW, please do not hesitate to add your Reviewed-by or Acked-by if you
> >are mostly satisfied with the patch (sans a few minor issues that you
> >should point out). I can't guarantee that I will always add your tags
> >(depends on when I commit the patch to my one of my public branches) but
> >I will try to do so.
> >
> >Thanks.
> >
> Sure, I see, thanks Dmitry.
> 

So was this reviewed-by? ;)

-- 
Dmitry

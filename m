Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1HCGCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:02:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37928 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1HCGCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:02:44 -0400
Date: Tue, 2 Aug 2011 23:02:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Amy Maloche <amaloche@codeaurora.org>
Subject: Re: [PATCH] input: misc: Add support for pm8xxx based vibrator driver
Message-ID: <20110803060237.GA23399@core.coreip.homeip.net>
References: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org>
 <CAM=Q2cvzsZO4dc6Ot_aYJyLW27TErgySdXRcHr1UDb5ua1uHAg@mail.gmail.com>
 <4E3798C1.3080800@codeaurora.org>
 <20110802064124.GA21319@core.coreip.homeip.net>
 <4E37BCA2.4010208@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E37BCA2.4010208@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 02:30:18PM +0530, Anirudh Ghayal wrote:
> Hi Dmitry,
> 
> On 8/2/2011 12:11 PM, Dmitry Torokhov wrote:
> >On Tue, Aug 02, 2011 at 11:57:13AM +0530, Anirudh Ghayal wrote:
> >
> >>Yes should have been dev_err.
> >>
> >>Dmitry, would you like me to submit another patch for this? I can
> >>make the @work change as well. Or would you make this minor change
> >>as well. Thank you.
> >>
> >
> >Anirudh, I made this plus a few more cosmetic changes, if you could try
> >the patch below and let me know if it still works I will commit it for
> >the next merge window.
> >
> 
> Thank you for making changes. I have tested the patch and it works fine.
> 

Thank you, I queued it for 3.2.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2KMHrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:47:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2KMHre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:47:34 -0500
Date: Tue, 13 Nov 2012 08:47:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/13] Win 8 support for digitizers
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1211130845270.15877@pobox.suse.cz>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Benjamin Tissoires wrote:

> Hi Guys,
> 
> here is the third version of this patchset.
> I think I included most of Henrik's comments.
> 
> Happy reviewing :)
> 
> Cheers,
> Benjamin
> 
> v1 introduction:
> So, this is an update for supporting Win 8 multitouch devices in the kernel.
> As I wanted to reliably forward the resolution, I noticed a bug in the
> processing of the unit_exponent in the hid core layer.
> Thus the fixes for hid-core and hid-input.
> 
> v2 changes:
> * added missing initial patch that prevents the series to be applied on top of Jiri's tree
> * update to include latest hid changes
> * taken into account Alan's patch: "hid: put the case in the right switch statement"
> 
> v3 changes:
> * splitted "round return value of hidinput_calc_abs_res" in a separate patch
> * export snto32 in hid.h as we need to use it in hid-input.c
> * didn't change all drivers, but add a field in hid_usage instead
> * add quirk MT_QUIRK_IGNORE_DUPLICATES so that any device can rely on it
> * easier understandable support of hovering devices
> * changed scan time definition
> * applied new definition of scan time in hid-multitouch
> * some other few things.

Benjamin,

thanks for the patchset.

I am fine with the HID-specific changes (and I have sent out my Acks to 
the invidivual patches).

For hid-multitouch changes, I'd like to have Reviewed-by: from Henrik as 
well. Henrik, are you planning to review this patchset, please?

Also the note from Dmitry on turning ABS_SCAN_TIME into 
EV_MSC/MSC_TIMESTAMP should be addressed.

Once this is finalized, I'd like to queue this for 3.8 in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs

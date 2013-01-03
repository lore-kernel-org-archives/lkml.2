Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3ACJo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:44:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab3ACJoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:44:23 -0500
Date: Thu, 3 Jan 2013 10:44:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Koukousoulas <pktoss@gmail.com>,
        Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: Rumble support for Jess/Saitek "color rumble pad"
In-Reply-To: <1355791689.12070.4.camel@localhost>
Message-ID: <alpine.LNX.2.00.1301031042530.27348@pobox.suse.cz>
References: <1355791689.12070.4.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012, Michael Karcher wrote:

> Hello developers (and testers)
> 
> The attached pad adds supports for another gamepad to the hid-pl driver.
> The "color rumble pad P580" marketed using the "Saitek" brand in
> Germany, and using a USB Vendor ID attributed to "Jess" seems to be
> electronically identical to the 4-field variant of the "Green Asia"
> gamepad.
> 
> The pad has been tested to support rumble strengths up to 255, not just
> 127. Currently the patch discriminates the pads by an if on the vendor
> ID, a bit in the driver_data field with definitely do better, but I
> recommend the owners of the 4-field green asia pad to verify whether the
> maximum rumble strength is indeed only 127, otherwise the condition
> should be removed entirely and 255 used in all cases.

Hi Michael,

thanks for the patch. A couple of requests before I can apply it:

- please provide the patch in-line in the e-mail body if your client 
  doesn't corrupt patches. It's eaiser to review it that way
- please add your Signed-off-by: line as described in 
  Documentation/SubmittingPatches
- don't forget to add the VID/PID to hid_ignore_list[], otherwise the 
  device <-> driver binding will not work properly

Thanks,

-- 
Jiri Kosina
SUSE Labs

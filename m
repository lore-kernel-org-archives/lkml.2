Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423618Ab2KOJge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:36:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422860Ab2KOJgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:36:32 -0500
Date: Thu, 15 Nov 2012 10:36:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris MacDonald <chris@fourthandvine.com>
Subject: Re: [PATCH] HID: usbhid: add quirk HID_QUIRK_NOGET to TPV optical
 touchscreen
In-Reply-To: <1352912036-6670-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1211151036190.15877@pobox.suse.cz>
References: <1352912036-6670-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Benjamin Tissoires wrote:

> Without this, the device is blocked in dmesg at:
> hid-multitouch 0003:25AA:8883.000X: usb_submit_urb(ctrl) failed: -1
> hid-multitouch 0003:25AA:8883.000X: timeout initializing reports
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab2LILiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:38:09 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:51046 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab2LILiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:38:07 -0500
Message-ID: <50C47811.7010503@ahsoftware.de>
Date: Sun, 09 Dec 2012 12:37:53 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121002 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Jiri Kosina <jkosina@suse.cz>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 1/2] HID: autodetect HID sensor hubs.
References: <1355015544-31579-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1355015544-31579-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.12.2012 02:12, schrieb Alexander Holler:
> It should not be necessary to add IDs for HID sensor hubs to lists
> in hid-core.c and hid-sensor-hub.c. So instead of a whitelist,
> autodetect such sensor hubs, based on a collection of type
> physical inside a useage page of type sensor. If some sensor hubs
> stil must be usable as raw devices, a blacklist might be created.

That patch didn't check if the device is a USB device and therfor
blutooth hid sensor hubs wouldn't still be handled as raw devices.

I send another patch 1/2 which checks the bus too.
Patch 2/2 still should be applied.

Regards,

Alexander

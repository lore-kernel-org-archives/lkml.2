Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1JMXfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:35:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1JMXfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:35:54 -0400
Date: Fri, 14 Oct 2011 01:35:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Terry Lambert <tlambert@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Driver for Primax keyboards violating USB HID spec
In-Reply-To: <1318548517-5289-1-git-send-email-tlambert@chromium.org>
Message-ID: <alpine.LNX.2.00.1110140134200.14768@pobox.suse.cz>
References: <1318548517-5289-1-git-send-email-tlambert@chromium.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Terry Lambert wrote:

> Primax keyboards with the issue this driver addresses report modifier
> keys as in band key events instead of as out of band modifier bits,
> resulting in the modifier keys generating key up events immediately
> before the keys they are intended to modify.  This driver rewrites
> the raw report data from such keyboards into USB HID 1.11 compliant
> report data.  It only matches the USB vendor and product IDs for the
> keyboard it has been tested on. Since there are several keyboards,
> notably a number of laptops and folding USB keyboards known to have
> similar unresolved problem reports, the list is expected to grow.
> 
> Signed-off-by: Terry Lambert <tlambert@chromium.org>

Terry,

thanks for the patch.

[ ... snip ... ]
> +static int px_input_mapping(struct hid_device *hid, struct hid_input *hi,
> +	struct hid_field *field, struct hid_usage *usage,
> +	unsigned long **bit, int *max)
> +{
> +	struct px_device *px = hid_get_drvdata(hid);
> +
> +	px->input_primax = hi->input;
> +
> +	/* Remap keys, if necesssary, here */
> +
> +	return 0;
> +}

I fail to see the point of this routine ... ?

Otherwise, the patch seems fine.

Thanks,

-- 
Jiri Kosina
SUSE Labs

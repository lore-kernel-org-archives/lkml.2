Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2LLJmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:42:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab2LLJmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:42:46 -0500
Date: Wed, 12 Dec 2012 10:42:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 1/2] HID: autodetect USB HID sensor hubs.
In-Reply-To: <1355053470-3939-1-git-send-email-holler@ahsoftware.de>
Message-ID: <alpine.LNX.2.00.1212121042100.19767@pobox.suse.cz>
References: <50C47811.7010503@ahsoftware.de> <1355053470-3939-1-git-send-email-holler@ahsoftware.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2012, Alexander Holler wrote:

> It should not be necessary to add IDs for HID sensor hubs to lists
> in hid-core.c and hid-sensor-hub.c. So instead of a whitelist,
> autodetect such USB HID sensor hubs, based on a collection of type
> physical inside a useage page of type sensor. If some sensor hubs
> stil must be usable as raw devices, a blacklist might be created.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

I like this change and would like to merge it, but I'd appreciate Ack from 
Srinivas first.

Srinivas?

Thanks,

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0LGOxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:53:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:54871 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0LGOxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:53:37 -0500
Date: Tue, 7 Dec 2010 15:53:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] input: mt: Move tracking and pointer emulation to
 input-mt
In-Reply-To: <1291722357-22820-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1012071553100.14806@pobox.suse.cz>
References: <1291722357-22820-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Henrik Rydberg wrote:

> The drivers using the type B protocol all report tracking information
> the same way. The contact id is semantically equivalent to
> ABS_MT_SLOT, and the handling of ABS_MT_TRACKING_ID only complicates
> the driver. The situation can be improved upon by providing a common
> pointer emulation code, thereby removing the need for the tracking id
> in the driver.  This patch moves all tracking event handling over to
> the input core, simplifying both the existing drivers and the ones
> currently in preparation.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> This is revision three of the patch, with changes to incorporate the
> active use of ABS_MT_TOOL_TYPE. Example usages are found in pen and
> touch tablets and simple dual touch devices. The report_slot_state()
> function now takes the tool type as argument, since a change in either
> tool type of touch state should trigger a new tracking id.
> 
> Thanks,
> Henrik
> 
>  drivers/hid/hid-3m-pct.c                |   30 +---------

Acked-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

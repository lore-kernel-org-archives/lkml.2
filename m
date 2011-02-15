Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1BOXEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:04:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab1BOXEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:04:34 -0500
Date: Wed, 16 Feb 2011 00:04:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add IRTOUCH infrared USB to
 hid_have_special_driver
In-Reply-To: <1297780428-3805-1-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1102160003420.2160@pobox.suse.cz>
References: <1297780428-3805-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Benjamin Tissoires wrote:

> Without this patch, the device is handled by hidinput and does
> not have the right behavior.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
> Hi guys,
> 
> In the previous patch including the support to IRTOUCH devices, I forgot 
> to add it to hid_have_special_driver. Sorry.

Hmm, this happens quite often to people submitting patches, but I normally 
catch it. This time my eyes have failed.

Thanks for the fix, applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2F1IbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:31:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2F1IbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:31:17 -0400
Date: Thu, 28 Jun 2012 10:31:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] HID: hid-multitouch: fix input mode feature
 command
In-Reply-To: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1206281030070.17549@pobox.suse.cz>
References: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, benjamin.tissoires wrote:

> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> 
> Zytronic panels shows a new way of setting the Input Mode feature.
> This feature is put in the second usage in the HID feature, instead
> of the first, as the majority of the multitouch devices.
> 
> This patch adds a detection step when the feature is presented to know
> where the feature is located in the report. We can then trigger the right
> command to the device. This removes the magic number "0" in the function
> mt_set_input_mode.

I have applied 1/3 and 3/3. For 2/3, Henrik raised concern which I'd like 
to have resolved first.

Thanks!

-- 
Jiri Kosina
SUSE Labs

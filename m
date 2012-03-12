Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2CLKZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:25:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab2CLKZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:25:40 -0400
Date: Mon, 12 Mar 2012 11:25:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] HID: multitouch: fix handling of buggy reports
 descriptors for Dell ST2220T
In-Reply-To: <1331053026-21272-3-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1203121124370.18356@pobox.suse.cz>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com> <1331053026-21272-3-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, benjamin.tissoires wrote:

> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> 
> LG multitouch panels, such as the one found in Dell ST2220T, has buggy
> reports descriptors. With the previous implementation, it was impossible
> to rely on the reports descriptors to determine how the different
> touches are emitted from the device.
> 
> This patch changes the splitting of the different touches in the report
> in a more robust way.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
> 
> This one gives me warning under Ubuntu (11.10 and 12.04 at least):
> drivers/hid/hid-multitouch.c: In function 'mt_input_mapping':
> arch/x86/include/asm/bitops.h:312:8: warning: array subscript is above array bounds [-Warray-bounds]
> arch/x86/include/asm/bitops.h:312:8: warning: array subscript is above array bounds [-Warray-bounds]
> 
> I don't get any warnings under Fedora. Any help would be great.

I am not getting any with my 4.3.4 and I am not able to spot any problem 
in that function. Seems like a gcc bug to me.

-- 
Jiri Kosina
SUSE Labs

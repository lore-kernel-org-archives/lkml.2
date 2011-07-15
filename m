Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1GOQuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:50:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44773 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab1GOQuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:50:15 -0400
Message-ID: <4E206FC2.9090804@ti.com>
Date: Fri, 15 Jul 2011 11:50:10 -0500
From: Pavan Savoy <pavan_savoy@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: "Savoy, Pavan" <pavan_savoy@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pavan_savoy@sify.com" <pavan_savoy@sify.com>
Subject: Re: [PATCH 0/4] drivers:misc: ti-st: platform specifics
References: <1310486113-29081-1-git-send-email-pavan_savoy@ti.com>
In-Reply-To: <1310486113-29081-1-git-send-email-pavan_savoy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2011 10:55 AM, Savoy, Pavan wrote:
> Greg,
>
> resending,
> since I didn't see these up on lkml.org
>
> These are the some of the patches which have gone on top of Texas Instrument's
> shared transport driver which fixes issues found during field testing.
> These include:
> a. removing an annoying and misleading debug message
> b. various platform hooks for enabling/disabling chip and communicating PM
> states of the WiLink chip.
> c. Re-initializing completion for make sure failed firmware download doesn't
> create a problem the next time around.
> d. fail-safe fix which happens upon corner cases when UART drops
> bytes or chip is too busy and hence sends across h/w error events.

Greg,

I hope you find some time to have a look at these.

Thanks & Regards,
Pavan Savoy.

>
>
> Pavan Savoy (3):
>    drivers:misc: ti-st: avoid a misleading dbg msg
>    drivers:misc:ti-st: platform hooks for chip states
>    drivers:misc: ti-st: reinit completion on ver read
>
> Vijay Badawadagi (1):
>    drivers:misc: ti-st: fail-safe on wrong pkt type
>
>   drivers/misc/ti-st/st_core.c |    9 ++++++++-
>   drivers/misc/ti-st/st_kim.c  |   13 +++++++++++++
>   drivers/misc/ti-st/st_ll.c   |   19 +++++++++++++++++++
>   include/linux/ti_wilink_st.h |   27 ++++++++++++++++++++++++++-
>   4 files changed, 66 insertions(+), 2 deletions(-)
>


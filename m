Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab1CXSaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:30:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:39494 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab1CXSaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:30:11 -0400
Date: Thu, 24 Mar 2011 19:30:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-ortek: update hid_info output
In-Reply-To: <1300989937-4329-1-git-send-email-herton.krzesinski@canonical.com>
Message-ID: <alpine.LNX.2.00.1103241928430.26754@pobox.suse.cz>
References: <1300989937-4329-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Herton Ronaldo Krzesinski wrote:

> Minor cosmetic issue, after adding Ortek PKB-1700 support I forgot to
> update the hid_info output string.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> ---
>  drivers/hid/hid-ortek.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-ortek.c b/drivers/hid/hid-ortek.c
> index f9b7dd4..6584c16 100644
> --- a/drivers/hid/hid-ortek.c
> +++ b/drivers/hid/hid-ortek.c
> @@ -22,7 +22,8 @@ static __u8 *ortek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  		unsigned int *rsize)
>  {
>  	if (*rsize >= 56 && rdesc[54] == 0x25 && rdesc[55] == 0x01) {
> -		hid_info(hdev, "Fixing up Ortek WKB-2000 report descriptor\n");
> +		hid_info(hdev, "Fixing up Ortek PKB-1700/"
> +			       "WKB-2000 report descriptor\n");
>  		rdesc[55] = 0x92;
>  	}
>  	return rdesc;

Hi,

the code is a bit different in my tree (hid.git tree, upstream-fixes 
branch) already, since I added support for additional device there. The 
patch is not needed anymore.

Thanks a lot for taking care anyway,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

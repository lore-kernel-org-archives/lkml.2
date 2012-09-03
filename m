Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2ICTWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:22:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58888 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2ICTWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:22:53 -0400
Message-ID: <50450388.6040506@lwfinger.net>
Date: Mon, 03 Sep 2012 14:22:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bogus memcpy in brcm80211 ai_detach
References: <20120903191335.GW16230@one.firstfloor.org>
In-Reply-To: <20120903191335.GW16230@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 02:13 PM, Andi Kleen wrote:
> gcc 4.8 warns for this memcpy. While the copy size is correct, the whole
> copy seems to be a nop because the destination is never used, and
> there's no need to use memcpy to copy pointers anyways. And the
> type of the pointer was wrong, but at least those are always the same.
>
> Just remove it.

Andi,

Have you compiled all of wireless with gcc 4.8? If so, can I assume that you 
will report warnings for other drivers?

Thanks,

Larry



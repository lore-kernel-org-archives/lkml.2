Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab0EYU3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:29:18 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3392 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab0EYU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:29:17 -0400
Message-ID: <4BFC331A.9030606@gmail.com>
Date: Tue, 25 May 2010 22:29:14 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100403 Lightning/1.0b2pre Shredder/3.0.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-05-25
References: <20100525170401.GE31753@tuxdriver.com>
In-Reply-To: <20100525170401.GE31753@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2010 20:29:14.0917 (UTC) FILETIME=[F1453550:01CAFC48]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On 05/25/10 19:04, John W. Linville wrote:
> Dave,
> 
> Here are a number of fixes intended for 2.6.35.  Included are some
> warning fixes from Randy, some smatch-identified fixes from Dan, some
> fixes for using ath9k and IBSS mode, the removal of a PCI ID that was
> optimistically added to ath9k, and a smattering of other driver fixes.
> This also includes a revert of "ath9k: Group Key fix for VAPs" which
> was reported to cause regressions due to a mac80211 change inside it
> that snuck past us... :-(
> 
> Anyway, these are mostly small(ish) and obvious.  Please let me know
> if there are problems!
> 
> Thanks,
> 
> John
> 
> ---
> 
> The following changes since commit acfbe96a3035639619a6533e04d88ed4ef9ccb61:

<snip>
> 
> Gertjan van Wingerde (2):
>       rt2x00: Fix rt2800usb TX descriptor writing.

The patch causing the breakage this patch fixes wasn't actually upstream yet. So, 
applying this patch only is now introducing a bug in 2.6.35. I guess it is better
to revert this patch for 2.6.35.

Sorry for not being clearer about it when sending the patch to you.

---
Gertjan.

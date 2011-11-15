Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1KOQoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:44:32 -0500
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:33516 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab1KOQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:44:30 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Nov 2011 11:44:30 EST
Message-ID: <4EC29534.7010502@adurom.com>
Date: Tue, 15 Nov 2011 18:37:08 +0200
From: Kalle Valo <kvalo@adurom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        ralf@linux-mips.org, juhosg@openwrt.org, rodrigue@qca.qualcomm.com,
        linville@tuxdriver.com, rmanohar@qca.qualcomm.com, patches@linaro.org
Subject: Re: [PATCH] ath9k: rename ath9k_platform.h to ath_platform.h
References: <1321356224-5053-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1321356224-5053-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangwook,

On 11/15/2011 01:23 PM, Sangwook Lee wrote:
> The patch series proposes to rename ath9k_platform.h to "ath_platform.h
> This header file handles platform data used only for ath9k,
> but it can used by ath6k as well. We can take "wl12xx.h" as
> as a example. Please let us change this file name so that
> other Atheors WLANs use this file for their own platform data

ath9k and ath6kl are very different devices, I'm not sure if sharing a
platfrom struct between the two is really a good idea. Most likely there
is very little the two drivers can share. What are your plans here?

I myself was thinking that we would have include/linux/ath6kl.h
dedicated just for ath6kl. That would makes things simpler.

Kalle

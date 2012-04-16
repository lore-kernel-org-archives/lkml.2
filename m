Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2DPQng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:43:36 -0400
Received: from mail.tpi.com ([70.99.223.143]:1270 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab2DPQne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:43:34 -0400
Message-ID: <4F8C4C06.1070307@canonical.com>
Date: Mon, 16 Apr 2012 10:42:46 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH linux-next 1/1] ath6k: Normalize use of FW_DIR
References: <1334337448-26270-1-git-send-email-tim.gardner@canonical.com> <1334337448-26270-2-git-send-email-tim.gardner@canonical.com> <4F8BBEAD.40305@qca.qualcomm.com>
In-Reply-To: <4F8BBEAD.40305@qca.qualcomm.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 12:39 AM, Kalle Valo wrote:
> On 04/13/2012 08:17 PM, Tim Gardner wrote:
>> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
>> Cc: "John W. Linville" <linville@tuxdriver.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> 
> Thanks, applied to ath6kl.git. But ar6004 hw1.2 supports wasn't in
> linux-next yet so I changed it as well. If you can, please check my changes:
> 
> https://github.com/kvalo/ath6kl/commit/2023dbb8310ab39ac1119a32ef52405f7a73f51f
> 
> Kalle

Looks good to me.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

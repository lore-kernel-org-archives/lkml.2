Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2JCKiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:38:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54610 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2JCKiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:38:20 -0400
Message-ID: <506C158D.4000906@ti.com>
Date: Wed, 3 Oct 2012 16:08:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Prabhakar <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH] ARM: davinci: dm644x: fix out range signal for ED
References: <1349246100-7477-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1349246100-7477-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2012 12:05 PM, Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> while testing display on dm644x, for ED out-range signals
> was observed. This patch fixes appropriate clock setting
> for ED.

Can you please clarify what you mean by "out range signal"? Are there
any user visible artifacts on the display? What was the clock being
provided earlier and what is the value after this patch?

Also, is the issue severe enough that this patch should be applied to
stable tree as well?

Thanks,
Sekhar

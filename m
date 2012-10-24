Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab2JXLUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:20:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2JXLUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:20:09 -0400
Message-ID: <5087CEDC.9050103@ti.com>
Date: Wed, 24 Oct 2012 16:49:56 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v2] ARM: dm365: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with
 V4L2_OUT_CAP_DV_TIMINGS
References: <1350998273-19769-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1350998273-19769-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 6:47 PM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> This patch replaces V4L2_OUT_CAP_CUSTOM_TIMINGS macro with
> V4L2_OUT_CAP_DV_TIMINGS. As V4L2_OUT_CAP_CUSTOM_TIMINGS is being phased
> out.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Sergei Shtylyov <sshtylyov@mvista.com>

Patches for mach-davinci should have a 'davinci:' prefix after 'ARM:'.
Can you please resend with that fixed?

Thanks,
Sekhar

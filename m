Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716Ab2JXLX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:23:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41979 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab2JXLX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:23:27 -0400
Message-ID: <5087CF66.6020805@mvista.com>
Date: Wed, 24 Oct 2012 15:22:14 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH v2] ARM: dm365: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with
 V4L2_OUT_CAP_DV_TIMINGS
References: <1350998273-19769-1-git-send-email-prabhakar.lad@ti.com> <5087CEDC.9050103@ti.com>
In-Reply-To: <5087CEDC.9050103@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2012 15:19, Sekhar Nori wrote:

>> This patch replaces V4L2_OUT_CAP_CUSTOM_TIMINGS macro with
>> V4L2_OUT_CAP_DV_TIMINGS. As V4L2_OUT_CAP_CUSTOM_TIMINGS is being phased
>> out.

>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Sergei Shtylyov <sshtylyov@mvista.com>

> Patches for mach-davinci should have a 'davinci:' prefix after 'ARM:'.
> Can you please resend with that fixed?

    Also, the patch is for DM365 EVM board, not DM365 SoC.

> Thanks,
> Sekhar

WBR, Sergei


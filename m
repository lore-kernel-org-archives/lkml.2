Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab2J0Ioy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:44:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44750 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab2J0Iov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:44:51 -0400
Message-ID: <508B9EEB.2070806@ti.com>
Date: Sat, 27 Oct 2012 14:14:27 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>
Subject: Re: [RESEND-PATCH] media:davinci: clk - {prepare/unprepare} for common
 clk
References: <1350920203-21978-1-git-send-email-m-karicheri2@ti.com> <CA+V-a8sbCyTTAm-x2Jr2_XxccRo0kjhVAYaVAibXHCqjZL7-nA@mail.gmail.com> <508AB1D2.40908@ti.com>
In-Reply-To: <508AB1D2.40908@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Murali,

On 10/26/2012 9:22 PM, Murali Karicheri wrote:
> On 10/25/2012 09:12 AM, Prabhakar Lad wrote:
>> Hi Murali,
>>
>> Thanks for the patch.  I'll  queue this patch for 3.8.
> Please check with Sekhar as well. This is a preparation patch for common
> clk framework support. ALso fixes some bugs on the existing code. As the
> clk
> patches are dependent on these patches, I would suggest you queue this
> against 3.7 rcx.

The -rc cycle is for fixes only so this cannot get merged into v3.7
as-is. If the patch has some fixes embedded, its a good idea to separate
them out (and have the feature parts come after the fixes in the patch
series) so they can be considered for -rc cycle. The current description
does not detail what the issue is and what its impact is so when you do
separate it out, please mention those as well. It will help determine
the severity of the issue and convince maintainers to include it in v3.7.

Thanks,
Sekhar

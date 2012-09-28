Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2I1Gg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:36:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2I1Ggy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:36:54 -0400
Message-ID: <5065457E.4040500@zytor.com>
Date: Thu, 27 Sep 2012 23:36:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lv Zheng <lv.zheng@intel.com>
CC: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [RESEND PATCH v4 0/2] ACPI: DBGP/DBG2 early console support for
 LPIA.
References: <cover.1347453194.git.zetalog@gmail.com> <cover.1348652044.git.lv.zheng@intel.com>
In-Reply-To: <cover.1348652044.git.lv.zheng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 10:36 PM, Lv Zheng wrote:
> Microsoft Debug Port Table (DBGP or DBG2) is used by the Windows SoC
> platforms to describe their debugging facilities.
> Recent Low Power Intel Architecture (LPIA) platforms have utilized
> this for the SPI UART debug ports that are resident on their debug
> boards.
>
> This patch set enables the DBGP/DBG2 debug ports as an Linux early
> console launcher.
> The SPI UART debug ports support is also refined to co-exist with this
> new usage model.

Hi Len,

You want to take this, or should I?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


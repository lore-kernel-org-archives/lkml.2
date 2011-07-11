Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1GKI1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:27:41 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:10496 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757371Ab1GKI1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:27:40 -0400
Message-ID: <4E1AB3F7.2070600@dsn.okisemi.com>
Date: Mon, 11 Jul 2011 17:27:35 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        tglx@linutronix.de
Subject: Re: [PATCH v4] pch_gpio: Support interrupt function
References: <1309486572-2789-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110704163137.GA28042@ponder.secretlab.ca> <4E128A7D.9020508@dsn.okisemi.com> <20110705035902.GB13713@ponder.secretlab.ca> <4E12A69C.8030709@dsn.okisemi.com>
In-Reply-To: <4E12A69C.8030709@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

(2011/07/05 14:52), Tomoya MORINAGA wrote:
> (2011/07/05 12:59), Grant Likely wrote:
>>> As we discussed before,
>>> without specifying PCH_IRQ_BASE,
>>> it seemed IRQ number collision issue occurred.
>>> Thus, I added PCH_IRQ_BASE.
>>
>> Then fix the irq collision. If the core code hands out an irq range
>> that is in-use by some other driver, then the other driver isn't
>> reserving it's irqs correctly and it needs to be fixed. Hacking
>> around the problem doesn't help anything in the long run.
>>
>
> I tried to work irq_alloc_descs with dynamic allocation.(Set 2nd
> parameter as 0).
> However it seems the issue remains to be seen.
> I attached dmesg output log, /proc/interrupts log and modified PCH-GPIO
> source code.
>
> Could you give me your opinion or information ?
>
> NOTE: I tested on linux-3.0-rc3
>
How is it going ?

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.

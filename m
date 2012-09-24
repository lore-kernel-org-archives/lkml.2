Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2IXOAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:00:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44880 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2IXOAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:00:46 -0400
Message-ID: <50606768.3080300@ti.com>
Date: Mon, 24 Sep 2012 10:00:08 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: <cyril@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <davidb@codeaurora.org>,
        <frank.rowand@am.sony.com>, <hsweeten@visionengravers.com>,
        <linus.walleij@linaro.org>, <marc.zyngier@arm.com>, <nico@linaro.org>,
        <paul.gortmaker@windriver.com>, <plagnioj@jcrosoft.com>,
        <rabin@rab.in>, <rmallon@gmail.com>, <rob.herring@calxeda.com>,
        <sboyd@codeaurora.org>, <sjg@chromium.org>, <tglx@linutronix.de>,
        <tj@kernel.org>, <vincent.guittot@linaro.org>, <vitalya@ti.com>,
        <will.deacon@arm.com>, <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 RESEND 09/17] ARM: LPAE: use phys_addr_t for initrd
 location and size
References: <1348242975-19184-1-git-send-email-cyril@ti.com> <1348242975-19184-10-git-send-email-cyril@ti.com> <20120924133826.GA26454@n2100.arm.linux.org.uk>
In-Reply-To: <20120924133826.GA26454@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/12 09:38, Russell King - ARM Linux wrote:
> On Fri, Sep 21, 2012 at 11:56:07AM -0400, Cyril Chemparathy wrote:
>> From: Vitaly Andrianov <vitalya@ti.com>
>>
>> This patch fixes the initrd setup code to use phys_addr_t instead of assuming
>> 32-bit addressing.  Without this we cannot boot on systems where initrd is
>> located above the 4G physical address limit.
>
> The description needs updating.  You're no longer using phys_addr_t for the
> initrd size.
>

Thanks.  Nico had pointed this out earlier.  I've fixed for v4.

Thanks
-- Cyril.

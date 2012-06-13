Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2FMSJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:09:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47662 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2FMSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:09:40 -0400
Message-ID: <4FD8D760.3070406@gmail.com>
Date: Wed, 13 Jun 2012 13:09:36 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 0/4] DT clock bindings
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com> <20120613152658.GE32111@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20120613152658.GE32111@tbergstrom-lnx.Nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On 06/13/2012 10:26 AM, Peter De Schrijver wrote:
> On Tue, Jun 12, 2012 at 04:41:47PM +0200, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> This series defines clock bindings for Device-Tree and adds kernel
>> support using the common clock infrastructure. The last patch enables
>> DT clock support for the Calxeda Highbank platform.
>>
>> I'm posting this again to solicit further review. There has been some
>> discussion[1], but no definite path forward. This series is not changed
>> from the last post other than rebasing to v3.5-rc2.
>>
>> Rob
>>
>> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/100932.html
>>
> 
> How would this binding work for clocks which can take a spinlock pointer as a
> init parameter (eg. clk-gate).

Other than fixed clocks, this makes no attempt at generic bindings.
There is still per clock init required which can allocate a spinlock if
necessary. If you look at the highbank code, it would be trivial to
initialize spinlocks as needed.

Rob

> Cheers,
> 
> Peter.

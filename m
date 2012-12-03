Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2LCNXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:23:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49553 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab2LCNXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:23:38 -0500
Message-ID: <50BCA7B6.5030807@ti.com>
Date: Mon, 3 Dec 2012 18:53:02 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@deeprootsystems.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 07/11] ARM: davinci - restructure header files for
 common clock migration
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-8-git-send-email-m-karicheri2@ti.com> <50967641.4090503@ti.com> <5098362D.1000007@ti.com>
In-Reply-To: <5098362D.1000007@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2012 3:27 AM, Murali Karicheri wrote:
> On 11/04/2012 09:05 AM, Sekhar Nori wrote:

[...]

>> I pushed the patches I fixed to devel-common-clk branch of my git tree.
>> It is build tested using davinci_all_defconfig but its not runtime
>> tested.
>>
>> Can you start from here and provide me incremental changes on top of
>> this? That way we can collaborate to finish this faster.
>>
>> Thanks,
>> Sekhar
>>
> I made a build from your branch and it doesn't boot up DM6446. I will

Okay so there were some silly issues (as expected from untested work)
like not even calling the DM644x common clock initializer function. I
have been able to fix them and now the devel-common-clk branch on my
tree boots on DM644x EVM. The work is still rough and I haven't fixed
many of the comments I gave you before. You can use the updated branch
to base your further work on and once you have something to share,
please put it on a public repo so I can take a look. I will try and
summarize all that I changed in a later mail. Wanted to get this message
out to you as soon as I can.

Thanks,
Sekhar

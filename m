Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2FLQXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:23:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44870 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2FLQXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:23:24 -0400
Message-ID: <4FD76CF6.8090801@gmail.com>
Date: Tue, 12 Jun 2012 11:23:18 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, mturquette@linaro.org,
        s.hauer@pengutronix.de, sboyd@codeaurora.org,
        Grant Likely <grant.likely@secretlab.ca>, skannan@codeaurora.org,
        shawn.guo@linaro.org
Subject: Re: [PATCH v3 0/4] DT clock bindings
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com> <20120612154735.GB19410@gmail.com>
In-Reply-To: <20120612154735.GB19410@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 10:47 AM, Mike Turquette wrote:
> On 20120612-09:41, Rob Herring wrote:
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
> 
> Hi Rob,
> 
> Just FYI, I was following the first thread but it did not seem to reach
> resolution.  Namely Saravana seemed to have some lingering concerns.
> But I'm definitely not ignoring this series.  I assume you still want
> this to go through me once everyone is on board?

Right. This is why I have reposted and copied those whom commented on my
pull request. I think at least some of Saravana's concerns boiled down
to not requiring using DT clock bindings and not requiring driver
changes to move to DT bindings. Both of these are met with this series.
A platform can still use clkdev tables for binding clocks to devices and
does not have to use DT for clocks. Drivers generally should not require
any changes that I'm aware of, but if there are any concrete examples
I'd like to know.

Yes, I think this should go thru you.

Rob

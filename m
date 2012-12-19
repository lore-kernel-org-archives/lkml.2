Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2LSO3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:29:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33570 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab2LSO3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:29:35 -0500
Message-ID: <50D1CF40.8000203@ti.com>
Date: Wed, 19 Dec 2012 09:29:20 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-keystone@list.ti.com>
Subject: Re: [PATCH - v2] spi: davinci: add OF support for the spi controller
References: <1355260839-29865-1-git-send-email-m-karicheri2@ti.com> <20121215002758.14D223E0BEC@localhost> <20121219131850.E421B3E0AD7@localhost>
In-Reply-To: <20121219131850.E421B3E0AD7@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 08:18 AM, Grant Likely wrote:
> On Sat, 15 Dec 2012 00:27:58 +0000, Grant Likely<grant.likely@secretlab.ca>  wrote:
>> On Tue, 11 Dec 2012 16:20:39 -0500, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>>> This adds OF support to DaVinci SPI controller to configure platform
>>> data through device bindings. Also replaces clk_enable() with
>>> of clk_prepare_enable() as well as clk_disable() with
>>> clk_disable_unprepare().
>>>
>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>> Reviewed-by : Grant Likely<grant.likely@secretlab.ca>
>> Applied, thanks.
>>
>> I did remove the OF_ALIAS_N property though. I know the COMPATIBLE one
>> uses it, but it is actually kind of redundant since it can also be
>> determined by counting the number of OF_ALIAS_* entries, and having the
>> _N one in there means extra work needs to be done to filter it out.
>>
>> Also, I had to add a #ifndef _LINUX_OF_PRIVATE_H wrapper around the
>> whole header file. This is needed for all header files to protect
>> against multiple includes.
> Ummm.... oops. I replied to the wrong email when applying another patch.
> Sorry for the noise.
>
> But I have applied your patch now. It will appear in linux-next after
> the merge window closes.
>
> g.
>
>
Grant,

Thanks for taking care of this.

Murali

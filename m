Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab2AUSj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:39:26 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:38867 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750980Ab2AUSjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:39:24 -0500
Message-ID: <4F1B140F.8080408@xenotime.net>
Date: Sat, 21 Jan 2012 11:37:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 4/14] kernel-doc: fix new warning in regulator core
References: <4F1B0BCE.4050505@xenotime.net> <20120121183512.GF10751@opensource.wolfsonmicro.com>
In-Reply-To: <20120121183512.GF10751@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2012 10:35 AM, Mark Brown wrote:
> On Sat, Jan 21, 2012 at 11:02:38AM -0800, Randy Dunlap wrote:
> 
>> @@ -2731,6 +2731,7 @@ static void rdev_init_debugfs(struct reg
>>   * @dev: struct device for the regulator
>>   * @init_data: platform provided init data, passed through by driver
>>   * @driver_data: private regulator data
>> + * @of_node: target of device structure (may be NULL)


> Please don't apply this, I can't actually parse that description so I'm
> fairly sure users will struggle also.  I'll try to get round to writing
> something better at some point.

Thanks.  Ah, 'of' is not the preposition above, it was meant to be
the acronym for open firmware.  :(

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2H3Xjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:39:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45869 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2H3Xju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:39:50 -0400
Message-ID: <503FF9E9.4020701@wwwdotorg.org>
Date: Thu, 30 Aug 2012 16:40:25 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
References: <1346186104-4083-1-git-send-email-broonie@opensource.wolfsonmicro.com> <503E8E6E.1010101@wwwdotorg.org> <20120830171918.GE4356@opensource.wolfsonmicro.com>
In-Reply-To: <20120830171918.GE4356@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/12 10:19, Mark Brown wrote:
> On Wed, Aug 29, 2012 at 02:49:34PM -0700, Stephen Warren wrote:
>> On 08/28/12 13:35, Mark Brown wrote:
>
>>> @@ -674,6 +676,7 @@ config ARCH_TEGRA
>>>   	select GENERIC_CLOCKEVENTS
>>>   	select GENERIC_GPIO
>>>   	select HAVE_CLK
>>> +	select HAVE_CUSTOM_CLK
>
>> For 3.7, Tegra will switch to the common clock framework. I think
>> this patch would then disable that. How should we resolve this -
>> rebase the Tegra common-clk tree on top of any branch containing
>> this patch in order to remove that select statement?
>
> I'd expect this to be applied on a separate branch so you should be able
> to rebase your conversion on top of it or merge it into your branch
> which should deal with things well enough I think?

That should work.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2GWUw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:52:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2GWUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:52:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6781"; a="213644539"
Message-ID: <500DB986.7090309@codeaurora.org>
Date: Mon, 23 Jul 2012 16:52:22 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin and Stephen,

Catalin Marinas - July 8, 2012, 9:18 a.m.
> On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
> 
>> Also, on Tegra at least and perhaps OMAP too, there are a few parts
>> of earlyprintk serial port setup (i.e. port selection) which happen
>> as part of the decompressor rather than the main kernel image, so
>> we'd have to re-jig that too.
> 
> Whatever we did on AArch32, if it was useful and we want to follow a
> similar model it needs porting given that the code cannot be shared. So
> there is nothing to re-jig but rather implement.
> 
> As for earlyprintk, you can initialise it in the decompressed kernel
> anyway. But even though it's a useful debugging tool, it goes against
> the single Image aim (at least the current printascii/addruart
> implementation). I don't have a proper implementation yet.

Would DCC [1] be a reasonably commonly available early printk mechanism
for the single image to provide?

1.
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0471c/BEIHGIBB.html

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

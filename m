Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1LERkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:40:41 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:58868 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932512Ab1LERkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:40:39 -0500
Message-ID: <4EDD0FED.7060301@xenotime.net>
Date: Mon, 05 Dec 2011 10:39:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux-next: Tree for Sept 28 (mrst)
References: <20110928200404.6ed0d6c34161d233be8994fd@canb.auug.org.au> <4E839B94.9040305@xenotime.net>
In-Reply-To: <4E839B94.9040305@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 03:11 PM, Randy Dunlap wrote:
> On 09/28/11 03:04, Stephen Rothwell wrote:
>> Hi all,
> 
> 
> When CONFIG_X86_INTEL_MID=y but CONFIG_X86_MRST is not enabled
> (this is on an i386/X86_32 build):
> 
> rtc.c:(.init.text+0x6234): undefined reference to `__mrst_cpu_chip'
> 
> Full randconfig file is attached.

Hm, it's now 20111205 and this build error is still around.
Is there any hope for getting it fixed?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

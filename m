Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab2AIT6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:58:48 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:54971 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933081Ab2AIT6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:58:47 -0500
Message-ID: <4F0B54A0.20905@xenotime.net>
Date: Mon, 09 Jan 2012 12:57:04 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org
Subject: Re: linux-next: Tree for Jan 9 (sound/soc vs. drivers/misc)
References: <20120109170457.4465dfc66a0eace4a2230fef@canb.auug.org.au>
In-Reply-To: <20120109170457.4465dfc66a0eace4a2230fef@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2012 10:04 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20120106:
> 
> This tree is still broken for sparc64 defconfig (at least).


AFAICT, all builds (on X86_32 or X86_64) have this kconfig warning:

drivers/misc/Kconfig:212:error: recursive dependency detected!
drivers/misc/Kconfig:212:	symbol ATMEL_SSC is selected by SND_ATMEL_SOC_SSC
sound/soc/atmel/Kconfig:9:	symbol SND_ATMEL_SOC_SSC is selected by SND_AT91_SOC_SAM9G20_WM8731
sound/soc/atmel/Kconfig:18:	symbol SND_AT91_SOC_SAM9G20_WM8731 depends on ATMEL_SSC


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

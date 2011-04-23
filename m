Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1DWC0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 22:26:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59688 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab1DWC0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 22:26:25 -0400
Message-ID: <4DB238BB.2010204@zytor.com>
Date: Fri, 22 Apr 2011 19:26:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: chris@csamuel.org, alan@lxorguk.ukuu.org.uk, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad
 Pentium Pro system
References: <201104222333.25546.chris@csamuel.org> <201104231016.23579.chris@csamuel.org> <SNT125-W638277FA9F3B49B316DC9FC3940@phx.gbl>,<201104231135.54966.chris@csamuel.org> <SNT125-W632CB71E47020C0C05FBDCC3940@phx.gbl>
In-Reply-To: <SNT125-W632CB71E47020C0C05FBDCC3940@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 06:46 PM, Yuhong Bao wrote:
> 
> If it was really BIOS-e801 and not BIOS-88 returning this, looks like this is probably a kernel bug in the parsing of the results.
>>> This would be easy to diagnose with DOS DEBUG with no himem.sys
>>> loaded.
>>
>> Would be happy to try with some instructions if it would help.
> Enter these instructions using the A command and execute with the T command:
> mov AX, E801
> INT 15
> INT 3
> And provide the results of the AX, BX, CX, and DX registers after the INT 15h.
>  

Executing these from DOS DEBUG won't give you real results, because DOS
intercepts this call.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


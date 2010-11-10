Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0KJTW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:22:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26619 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab0KJTW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:22:28 -0500
Message-ID: <4CDAF0D8.1000100@kernel.org>
Date: Wed, 10 Nov 2010 11:22:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] x86-64: more fixes and cleanup to AMD Fam10 MMCONF	 enabling
References: <4CD3F18E0200007800020B6D@vpn.id2.novell.com> <4CD4443F.8000008@kernel.org> <4CD7BD310200007800020E13@vpn.id2.novell.com>
In-Reply-To: <4CD7BD310200007800020E13@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2010 12:04 AM, Jan Beulich wrote:
>>>> On 05.11.10 at 18:51, Yinghai Lu <yinghai@kernel.org> wrote:
>> On 11/05/2010 03:59 AM, Jan Beulich wrote:
>>> Unfortunately it turned out the original code had more issues: We want
>>> to place the region above 4G in any case (even if TOM2 isn't enabled
>>> or invalid), and the base mask definition was improperly typed (thus
>>> causing shifts by FAM10H_MMIO_CONF_BASE_SHIFT to produce other than
>>> the intended result). Fixing this in turn allowed simplifying the MMIO
>>> region detection code, as regions ending below TOM2 now aren't of
>>> interest anymore.
>>>
>>> This will only apply cleanly on top of yesterday's patch titled
>>> "x86-64: fix and clean up AMD Fam10 MMCONF enabling".
>>
>> I don't think we have systems that have Enable bit set, but TOM2 < 4G.
> 
> I suppose that's true, but making the kernel independent of
> BIOS flaws (especially when it's that cheap) seems like a good
> idea to me. But of course, if that's what would be hindering
> acceptance of the patch, I'd re-submit with that part dropped.

I'm ok with your change.

Please come out one updated version with meaningful MACRO.

Thanks

	Yinghai

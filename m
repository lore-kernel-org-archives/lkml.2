Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab0H0UuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:50:00 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:41204 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0H0Ut6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:49:58 -0400
Message-ID: <4C7824F2.1050709@mandriva.org>
Date: Fri, 27 Aug 2010 23:49:54 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100809 Mandriva/3.1.2-3mdv2011.0 (2011.0) Thunderbird/3.1.2
MIME-Version: 1.0
To: Matteo Croce <matteo@openwrt.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Natale Vinto <ebballon@gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com> <4C780888.9000301@zytor.com> <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com>
In-Reply-To: <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.08.2010 23:15, Matteo Croce skrev:
> On Fri, Aug 27, 2010 at 8:48 PM, H. Peter Anvin<hpa@zytor.com>  wrote:
>> You're doing user-space references without get_user().
>>
>>         -hpa
>>
>> --
>> H. Peter Anvin, Intel Open Source Technology Center
>> I work for Intel.  I don't speak on their behalf.
>>
>>
>
> Here with get_user.
> I CC Natale which is my beta tester, he have some Alix boards running 24/24
> with my patch
>
> --- a/arch/x86/kernel/Makefile	2010-08-27 19:42:01.795858001 +0200
> +++ b/arch/x86/kernel/Makefile	2010-08-27 19:42:12.525858001 +0200
> @@ -88,6 +88,8 @@
>   obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
>
>   obj-$(CONFIG_K8_NB)		+= k8.o
> +obj-$(CONFIG_GEODE_NOPL)	+= nopl_emu.o
> +obj-$(CONFIG_GEODE_NOPL)	+= nopl_emu.o

Same line added twice...

--
Thomas

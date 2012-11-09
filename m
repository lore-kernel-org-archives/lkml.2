Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab2KIIhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:37:40 -0500
Received: from nbd.name ([46.4.11.11]:37630 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab2KIIhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:37:35 -0500
Message-ID: <509CC092.8090609@phrozen.org>
Date: Fri, 09 Nov 2012 09:36:34 +0100
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Huacai Chen <chenhc@lemote.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, alsa-devel@alsa-project.org,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hua Yan <yanh@lemote.com>,
        Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org,
        Hongliang Tao <taohl@lemote.com>, Jie Chen <chenj@lemote.com>
Subject: Re: [alsa-devel] [PATCH V6 12/15] ALSA: HDA: Make hda sound card
 usable        for Loongson
References: <1345193015-3024-1-git-send-email-chenhc@lemote.com>        <1345193015-3024-13-git-send-email-chenhc@lemote.com> <s5hy5ldvq9e.wl%tiwai@suse.de>
In-Reply-To: <s5hy5ldvq9e.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/12 11:09, Takashi Iwai wrote:
> At Fri, 17 Aug 2012 16:43:32 +0800,
> Huacai Chen wrote:
>> >
>> >  Lemote A1004(Laptop) and A1205(All-In-One) use Conexant's hda codec,
>> >  this patch modify patch_conexant.c to add Lemote specific code.
>> >
>> >  Both A1004 and A1205 use the same pin configurations, but A1004 need
>> >  to increase the default boost of internal mic.
>> >
>> >  Signed-off-by: Jie Chen<chenj@lemote.com>
>> >  Signed-off-by: Huacai Chen<chenhc@lemote.com>
>> >  Signed-off-by: Hongliang Tao<taohl@lemote.com>
>> >  Signed-off-by: Hua Yan<yanh@lemote.com>
>> >  Cc:alsa-devel@alsa-project.org
> Looks good.
> 	Reviewed-by: Takashi Iwai<tiwai@suse.de>
>
> Should I apply it to sound git tree or all patches will go through
> mips tree?
>
>
> thanks,
>
> Takashi
>


Hi Takashi,

did you take this patch ? I will queue several of the other patches from 
the series for 3.8 and let them go upstream via the mips tree. We have 
this patch open in the linux-mips patchwork. I would set it to "Other 
Subsystem" if you took it already.

Thanks,
	John

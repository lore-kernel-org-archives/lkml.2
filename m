Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2LLRl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:41:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab2LLRl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:41:56 -0500
Message-ID: <50C8C1D1.2000506@zytor.com>
Date: Wed, 12 Dec 2012 09:41:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Jamie Gloudon <jamie.gloudon@gmail.com>,
        fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
References: <20121001161151.GA2640@darkstar> <20121001162745.GD23181@x1.osrc.amd.com> <506A8479.8030103@zytor.com> <CACJDEmpXHoOYK-8F3a4nQi5GELnRSmdmWdU=i9PkNuxGcyjZRg@mail.gmail.com> <506B3AC2.2090108@zytor.com> <CACJDEmqNGsigBBktbnptbv3G5VD98F3htfwhx9mVCvz6mRQ0oQ@mail.gmail.com>
In-Reply-To: <CACJDEmqNGsigBBktbnptbv3G5VD98F3htfwhx9mVCvz6mRQ0oQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 06:13 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 2, 2012 at 3:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 10/02/2012 12:00 PM, Konrad Rzeszutek Wilk wrote:
>>>
>>> When he got interrupted did he have any beta patches to dracut that
>>> could be posted?
>>>
>>
>> To *dracut*?
>
> The replacement for mkinitrd. You know the thing that creates your
> initramfs.cpio.gz.
>

Yes... it just seems that mucking with dracut is the last step in the 
chain.  If your boot loader doesn't support initramfs concatenation, (a) 
complain to your bootloader author, (b) you can just use "cat"...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


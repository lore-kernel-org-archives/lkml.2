Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2HOAvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:51:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48647 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab2HOAvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:51:17 -0400
Message-ID: <502AF27D.2010902@zytor.com>
Date: Tue, 14 Aug 2012 17:51:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Marko Kohtala <marko.kohtala@gmail.com>, linux-kernel@vger.kernel.org,
        mjg@redhat.com
Subject: Re: [PATCH] efi: add efi_runtime state checking
References: <CAJ0yFaxO-ZU7d_RNbQ3y1cfB5EJL9wgvmgZk-nmkVOLoBRH88A@mail.gmail.com> <1340832957-7386-1-git-send-email-olof@lixom.net> <4FEB80A5.8020806@zytor.com> <CAOesGMhzAmpX0sSFv4w+=Y4Uzh77aa3_QW3JW=eurfo22dRMoA@mail.gmail.com>
In-Reply-To: <CAOesGMhzAmpX0sSFv4w+=Y4Uzh77aa3_QW3JW=eurfo22dRMoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 10:02 AM, Olof Johansson wrote:
> On Wed, Jun 27, 2012 at 2:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/27/2012 02:35 PM, Olof Johansson wrote:
>>>
>>> This adds an efi_runtime variable indicating whether the
>>> efi runtime services are available. The only time they are
>>> expected to not be available is when a 32-bit kernel has been
>>> booted using 64-but EFI and vice versa.
>>>
>>> It also adds checking to the two locations where functions are
>>> called; x86 reboot and efivars.
>>>
>>
>> OK, stupid question:
>>
>> Why is this different from the efi_enabled variable, or rather: why is it
>> different from what the efi_enabled variable *should* be?  If runtime
>> services aren't available the only "EFI" that is available to the kernel are
>> the data structures passed in, and those can be checked directly...
>
> Excellent question, and I think it would work to turn off efi_enabled
> towards the end of setup_arch() for non-native boots. That'd solve all
> these problems, I believe.
>
> I'll try it out and revise this patch. It might take me a day or two
> to get cycles for it.
>

Ping?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


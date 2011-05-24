Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1EXOQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:16:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61193 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab1EXOQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AIlEkj4oWK1hwYfgGZ6kHDPV4MJzC4v9Rx9sHzpv3C8CFEJxauWkfV/tu5XeGMDmLI
         +bnQyAmydM8Wvn/DK4fy4ZAaVqRHtc/ov/0TPsAPORKdxM1gidBPORzjtuSOBxye9F+R
         OOXYpG2Ddb8HX2f1tmMHrOK/vlkhlTvI0wi3I=
MIME-Version: 1.0
In-Reply-To: <BANLkTimCaEPVeBj_00HvqGp7j+_PUvs2Fg@mail.gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
	<BANLkTi=Xtunb3Qocw_AWZyAkBak52=njWQ@mail.gmail.com>
	<BANLkTinNn_nx1Wd8ocUHe2WipFkUK0o-2A@mail.gmail.com>
	<BANLkTi=UeEEj0fRb9v1viFpUOWvmrSHM2g@mail.gmail.com>
	<BANLkTimcxvdXeyqP+_h=JQwiay_PH8awkA@mail.gmail.com>
	<BANLkTimCaEPVeBj_00HvqGp7j+_PUvs2Fg@mail.gmail.com>
Date: Tue, 24 May 2011 23:16:13 +0900
X-Google-Sender-Auth: 6oWSSMzCgy2NzGeEPUd3Ud3NhcI
Message-ID: <BANLkTikeUMFyLuWcHbW4TrF1wqM8_F_Vnw@mail.gmail.com>
Subject: Re: ramoops: is using platform_drivers correct?
From: Kyungmin Park <kmpark@infradead.org>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, marco.stornelli@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:12 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, May 24, 2011 at 2:14 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>> On Tue, May 24, 2011 at 2:49 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> Huh? Is this for x86 too? Why so unfriendly for end-users?
>> I don't know which address is acceptable for x86, in case of ARM, each
>> SoCs has different SRAM address. so it's not good to define for all
>> SoCs and ARM.
>>>
>>> I think we need some kernel parameter like 'crashkernel=' (or memmap=)
>>> to reserve memory for ramoops, right?
>>
>> The first implementation is just module parameters.
>> ramoops.address=0x??????? ramoops.size=0x????. So I patched it as
>> using platform devices.
>> and the reason use the platform is it's dependent on each SoCs and board usage.
>>
>
> But the result is that this makes end-users harder to use it.
>
> Using platform API still relies on a hard-code address, at least in
> your example,
> so, why not leave it as a module parameter to let user to find the
> correct address?

It's possible. I just make it possible to use the platform driver. you
can specify the original method.

Thank you,
Kyungmin Park
>

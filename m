Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1EXOMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:12:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35759 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1EXOMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y3QXctiq5yG7qaHCKzFEBXIhnKY2A2Bpy8YZFSvOnBVq0cu3m0OPS2B1UvElibP4Ku
         K/j71cUULTFmVYUNlXxxNkg9LqivjVXAISrbdGpIbUaC+ML0zl9pnRCmsXw+QWA4Tvyv
         mIUi3PGFkw1isshuMD981n16jCkB7d4dOw3tE=
MIME-Version: 1.0
In-Reply-To: <BANLkTimcxvdXeyqP+_h=JQwiay_PH8awkA@mail.gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
	<BANLkTi=Xtunb3Qocw_AWZyAkBak52=njWQ@mail.gmail.com>
	<BANLkTinNn_nx1Wd8ocUHe2WipFkUK0o-2A@mail.gmail.com>
	<BANLkTi=UeEEj0fRb9v1viFpUOWvmrSHM2g@mail.gmail.com>
	<BANLkTimcxvdXeyqP+_h=JQwiay_PH8awkA@mail.gmail.com>
Date: Tue, 24 May 2011 22:12:09 +0800
Message-ID: <BANLkTimCaEPVeBj_00HvqGp7j+_PUvs2Fg@mail.gmail.com>
Subject: Re: ramoops: is using platform_drivers correct?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, marco.stornelli@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 2:14 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Tue, May 24, 2011 at 2:49 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> Huh? Is this for x86 too? Why so unfriendly for end-users?
> I don't know which address is acceptable for x86, in case of ARM, each
> SoCs has different SRAM address. so it's not good to define for all
> SoCs and ARM.
>>
>> I think we need some kernel parameter like 'crashkernel=' (or memmap=)
>> to reserve memory for ramoops, right?
>
> The first implementation is just module parameters.
> ramoops.address=0x??????? ramoops.size=0x????. So I patched it as
> using platform devices.
> and the reason use the platform is it's dependent on each SoCs and board usage.
>

But the result is that this makes end-users harder to use it.

Using platform API still relies on a hard-code address, at least in
your example,
so, why not leave it as a module parameter to let user to find the
correct address?

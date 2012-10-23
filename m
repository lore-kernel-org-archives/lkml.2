Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2JWDIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:08:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56436 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2JWDIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:08:02 -0400
MIME-Version: 1.0
In-Reply-To: <20121023025304.GA21810@kroah.com>
References: <1350287745-14442-1-git-send-email-sj38.park@gmail.com>
 <507D08FE.4070902@bluegiga.com> <20121022205626.GA4368@kroah.com>
 <CAEjAshoH2CJpnq-mt1TB6XB3i22QM+UeTKzr__ZgjHNUts3odA@mail.gmail.com>
 <CAEjAshqiVPA86fYNehmAEqiiZt0tGBvhu3ntFy+7XA4oLZKtRg@mail.gmail.com> <20121023025304.GA21810@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 23 Oct 2012 12:07:41 +0900
Message-ID: <CAEjAshq-u8P1JLF=t4_A7tn-oxKCL0_QrAAeYwQA1D0Kh2hm9A@mail.gmail.com>
Subject: Re: [PATCH] staging: csr: fix coding style
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for fast reply, Greg.

I was very impressed by your session at Linux Forum,
sent linux kernel patch, made a document about your session(write and
submit your first Linux kernel patch) in Korean, and my patch merged,
have discussion with Linux kernel guys...

These whole thing about my first kernel patch were fantastic and great
experience.

I think I got realized meaning & fun of F/OSS a little bit ;)
So, I would never stop contributing to Linux in any ways.

Thank you very much, Greg, and whole kernel people.

Thanks and Best Regards.
SeongJae Park.

On Tue, Oct 23, 2012 at 11:53 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 23, 2012 at 11:41:06AM +0900, SeongJae Park wrote:
>> Hello,
>>
>>
>> I think it was my mistake.
>>
>> CsrThread is enclosed by macro #ifdef __KERNEL__
>> and it used by csr_framework_ext.h as CsrThreadHandle type(typedef
>> used at csr_framework_ext_types.h).
>>
>> I think that's why I didn't see build failure.
>
> When building the driver __KERNEL__ is defined :)
>
>> So, I think I should not remove CsrThread.
>> If there is anything I missed or wrong, Please let me know.
>
> No, you are right, this can't be removed just yet, so all is good.
>
> If you want to send more patches cleaning stuff up like this one, that
> would be great.
>
> thanks,
>
> greg k-h

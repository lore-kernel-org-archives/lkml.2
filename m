Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2IFDYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:24:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55845 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2IFDYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120906000603.GA7043@kroah.com>
References: <6721797.222311346888851339.JavaMail.weblogic@epml19>
	<20120906000603.GA7043@kroah.com>
Date: Thu, 6 Sep 2012 08:54:16 +0530
Message-ID: <CAK7N6vpGsrF-VrAOO0nULOXNLzMfK-+eV4UOn0ch-S1zSH0rEQ@mail.gmail.com>
Subject: Re: Re: [PATCH -next] extcon: extcon-arizona depends on INPUT
From: anish singh <anish198519851985@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 5:36 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 05, 2012 at 11:47:31PM +0000, MyungJoo Ham wrote:
>> > On Wed, Sep 05, 2012 at 11:28:03AM +0800, Mark Brown wrote:
>> > > On Tue, Sep 04, 2012 at 04:51:00PM -0700, Randy Dunlap wrote:
>> > >
>> > > > This build error still happens in linux-next of 20120904.
>> > >
>> > > > Can we get the patch merged for linux-next?
>> > >
>> > > Greg's the one managing extcon in -next.
>> >
>> > Yeah, can someone forward this to me so I can apply it?  I can't seem to
>> > find it anywhere...
>> >
>> > greg k-h
>>
>> I've been creating "extcon-for-next" tree at git.infradead.org
>> I'll rebase the branch base on your driver-core-next
>>
>> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next
Is it possible to apply all the patches found here?I can see that some
couldn't make
it to your driver tree.
>
> Don't worry, I've already applied this patch now.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1DLPL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:11:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35237 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab1DLPL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=H+Yc5TbIrFrT6i0EF4n8szLmpJx6XSjLh//88QoPTvYtVCVyIpqhbZ83xdjclK1aW5
         45/aQi29mBXorJwDCCqzB8i3PXQQDkGkJr4xkeNMP1+8+Q3z4hg7tOzYqjVt+KuIZI50
         1s5a20uHyrAVowfsB4N8akmqOdFYvn00MDT6k=
MIME-Version: 1.0
In-Reply-To: <20110412144330.GB20815@atrey.karlin.mff.cuni.cz>
References: <20110317064523.GA1995@ucw.cz> <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
 <20110322133034.GA15475@atrey.karlin.mff.cuni.cz> <m1bp0zylgg.fsf@fess.ebiederm.org>
 <20110412144330.GB20815@atrey.karlin.mff.cuni.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 12 Apr 2011 22:46:25 +0800
Message-ID: <BANLkTikZXjfD82DxoahkvUo+26cjvOKZmw@mail.gmail.com>
Subject: Re: reboot/kexec in 2.6.38
To: Cyril Hrubis <metan@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
        rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:43 PM, Cyril Hrubis <metan@ucw.cz> wrote:
> Hi!
>> >> I think it's config issue. Never heard of this.
>> >
>> > I've just compiled and booted 2.6.38. The kernel boots without problems when
>> > flashed in. But I've had no success with kexec, the last lines I see are:
>> >
>> > Starting new kernel
>>
>> Enable early_printk to a serial port if you can.
>>
>> There is definitely an issue in 2.6.38 where kdump doesn't work, that
>> right now looks like a memblock issue.
>
> Finaly got time to solder serial adapter...
>
> And now, after I configured kernel to print to both ttyS0 serial console and
> tty0 the kexec started to work.

Cool. Please help check why it didn't work, and see if we have something
broken.

>
> --
> metan
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0KAO1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:27:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43628 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab0KAO1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ny7jFhfSFehnxrqU/ac8F3CyPpYFWzh1LKcwh+vyA2OKz1/s3kdl71p8MdwQGYaDI9
         8aZKv08jUJpLnLV+WIteWiGjgyr/grCi4TTHCn8Ql1bCCOu9CtZszM6KX9t7mldBIYX0
         mltPKYt7+DQPpEClmmAxWOWPWrMPFN8ICiqnE=
MIME-Version: 1.0
In-Reply-To: <20101101.225758.12584142.ryusuke@osrg.net>
References: <AANLkTinQ9NdEU+dp35sKp8u1tFu2NR2iX59wi-3wBFeH@mail.gmail.com>
	<AANLkTim=4GBFzMiAaGbs6uWbi1g2ZQGRYR55i4bO0X49@mail.gmail.com>
	<AANLkTimqkGH3PMfyL02R9agaxbP9t+BzjqLUaPK=ynu8@mail.gmail.com>
	<20101101.225758.12584142.ryusuke@osrg.net>
Date: Mon, 1 Nov 2010 19:57:21 +0530
Message-ID: <AANLkTi=fyNErf_mCi4hxUR12EdaUX5VaifC_j0dm8r1_@mail.gmail.com>
Subject: Re: Where can I find -rc kernels?
From: Ramya Desai <ramya.desai@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: trapdoor6@gmail.com, horms@verge.net.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 7:27 PM, Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:

>> >> I did not find the complete sources in that link. I need complete
>> >> sources by which I can build the kernel images. OR Is there any
>> >> procedure for merging these changes into any stable kernel version
>> >> (2.6.36) for making it 2.6.37-rc1.
>> >>
>> >> Thanks and Regards,
>> >> Ramya.
>> >
>> > I guess It just hasn't been published there yet. Not present in git
>> > tree either - I still have 2.6.36-09871-g3985c7c and 'git pull' says:
>> > Already up-to-date.
>> >
>> It's out now at http://www.kernel.org/
>> But still can't pull it from git.
>> Thanks,
>> Tomasz
>
> v2.6.37-rc1 is in the git tree.
>
> It looks like only master branch hasn't been updated yet.
>
> Ryusuke Konishi

Dear All,

Thanks to every one.

The kernel version 2.6.37-rc1 is NOW available at
http://www.kernel.org/pub/linux/kernel/v2.6/testing/. I guess, it is
updated recently. Anyhow, thanks to all.

Thanks and Regards,
Ramya.

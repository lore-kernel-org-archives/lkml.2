Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958Ab2DLDCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:02:25 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55597 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761915Ab2DLDCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <4F864399.8060105@zytor.com>
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com> <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
 <20120412010804.GI6589@ZenIV.linux.org.uk> <CAPXgP13zqFMTsndaW3YVZEA=aKMGsG-nO+i8k9frmSAzUNyrzA@mail.gmail.com>
 <4F864399.8060105@zytor.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 12 Apr 2012 05:02:01 +0200
Message-ID: <CAPXgP11W6U3VHVUPRWV2BspCY6W=FP=UhknO9gF+3UJy442vrA@mail.gmail.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:53, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/11/2012 07:27 PM, Kay Sievers wrote:
>>
>> Yeah, and? The dev_t still works from the static /dev/ like it didi 10
>> years ago. All good.
>
> That *is* the legacy mode which we'd like to get rid of.

Not sure if that will work. We might need to keep that for a while.
And static /dev and old udevs and mdev and whatever will just work as
they do today.

But the non-legacy mode compile option can be, as far as I see, still
be made working without requiring mount options and without requiring
any userspace changes.

What we get rid of then is not the legacy support, but the need to
manually switch userspace over. It's just a compile option then, and
people with static or ancient stuff do not switch, and everybody else
gets switched and will not notice.

Kay

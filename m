Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0EKRjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:39:37 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:61586 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0EKRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=U9cVkkyc+dQ1uXcDuapuezJqNRQubvNnBQBnOCUsUFgaBnyAM3sVM7BJTsdFsRGCC8
         C8bWiVgd+XRp4QnPwNWXknxi+djsXBoJfUQ3KSgIHE7ZaFWPRnD0JIujx5XeSv1knxOt
         csmYckzW2g7y/jqn306ChUy14S9icIfIUbVZY=
MIME-Version: 1.0
In-Reply-To: <89kc63$grtht6@fmsmga002.fm.intel.com>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
	 <89kc63$grtht6@fmsmga002.fm.intel.com>
Date: Tue, 11 May 2010 23:09:34 +0530
Message-ID: <AANLkTinSW9N825tAG1KePESPEsXynB4oGFvSkVrbxXkC@mail.gmail.com>
Subject: Re: DRM Error on Acer Aspire One
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On Tue, May 11, 2010 at 9:40 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 11 May 2010 20:30:07 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>> Hello,
>>
>> With latest git kernel, I am getting following DRM error and not
>> getting XWindows :
>
> [snip]
>
> Hmm, there are still patches for capturing error state that haven't gone
> upstream, shame on me.
>
> That error is a secondary issue to the GPU hang that is being reported. If
> it is a regression caused by a kernel update it would be very useful if
> you could bisect to the erroneous commit.
>

Earlier I was using Moblin, I switched to Fedora and start getting
this error. I have also tested different kernel versions but getting
same error, so I do not think this is a regression.

moblin dmesg : http://userweb.kernel.org/~jaswinder/moblin/dmesg-moblin_2633rc5.txt

Thanks,
--
Jaswinder Singh.

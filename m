Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab1DQK1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 06:27:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56417 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1DQK1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 06:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PrAOpjvwB6oLReYh3HXaJiknTUoW7HTNMpiZTvrjWIQLrDBa3nUbeVKED2uQR7WmKH
         ymzjU/1QRFYczqFhkIiLP255Y98hwAkxU7bp7euu5uk2LYCv6QrKsQ0NrWTqee5hlDaO
         rtpeWF2NY3FBrYRxdFUrO+4SHqo7Am5sdKCpk=
MIME-Version: 1.0
In-Reply-To: <BANLkTinAres6c8JaHA0Nuijany4XXyv67A@mail.gmail.com>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
	<BANLkTinn8xfyFArd4Q9aA5N47BoZ_rgCxw@mail.gmail.com>
	<BANLkTinMh7bofvSNW0gEoqaKvs27-xDGpQ@mail.gmail.com>
	<BANLkTinAres6c8JaHA0Nuijany4XXyv67A@mail.gmail.com>
Date: Sun, 17 Apr 2011 12:27:29 +0200
Message-ID: <BANLkTimoWT1K9QLs_-ucQNi1rt4e+4RYUw@mail.gmail.com>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the
 last build
From: Francis Moreau <francis.moro@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 6:57 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Sat, Apr 16, 2011 at 10:00 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>> On Sat, Apr 16, 2011 at 10:26 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> So why not just put that line into your script?
>>>
>>
>> Because this line was an _example_ of how the makefile could had been invoked.
>>
>> But the script has currently no idea how the previous invocation was
>> made, hence my question.
>
> You use a bad design, why not just pass these parameters to your script?
> Something like,
>
> $ ./your_script CC=my-gcc CFLAGS="-g -fwhatever"
>
> or whatever you want.
>

Yes, I think I'll continue to do that.

Thanks
-- 
Francis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1DQE5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 00:57:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45893 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1DQE5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 00:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RvEZe4D+zj+9Bqz0YfEnutyf2WvY4jr2xmdsjYnQG0GimecNRgi6Pil+p/NuF1Plga
         uhT5BTD4Ni7eoSxNl+t1LbDCGyo9CLYAHq5U9bubJog2NJzT4NXQf4UIAD3NaXM96lrI
         4mqPN82e9UedxHi6dGncsM4vyQ7NzUqb7JUYc=
MIME-Version: 1.0
In-Reply-To: <BANLkTinMh7bofvSNW0gEoqaKvs27-xDGpQ@mail.gmail.com>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
	<BANLkTinn8xfyFArd4Q9aA5N47BoZ_rgCxw@mail.gmail.com>
	<BANLkTinMh7bofvSNW0gEoqaKvs27-xDGpQ@mail.gmail.com>
Date: Sun, 17 Apr 2011 12:57:05 +0800
Message-ID: <BANLkTinAres6c8JaHA0Nuijany4XXyv67A@mail.gmail.com>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the
 last build
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 10:00 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> On Sat, Apr 16, 2011 at 10:26 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> So why not just put that line into your script?
>>
>
> Because this line was an _example_ of how the makefile could had been invoked.
>
> But the script has currently no idea how the previous invocation was
> made, hence my question.

You use a bad design, why not just pass these parameters to your script?
Something like,

$ ./your_script CC=my-gcc CFLAGS="-g -fwhatever"

or whatever you want.

Also, if you really have to read the previous command (I doubt),
you can use the `history` command.

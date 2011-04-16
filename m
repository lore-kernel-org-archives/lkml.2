Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1DPI0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:26:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37783 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1DPI0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FhtE1fcN9u/WRfL826a2Y/d0ZvorfZR9CPe5zgUoy6WHUxWVuNSxpmvtsqWe/K5B6U
         nflTNZcrB7SrNHEkFU2V7H5BhwI5p4L3J8vipCaLDMuBWNCBuKFWYBInm0WD8vxEoJci
         NhViJYG+9A2qwTOoczb1RBZYF+74i8e+U7shc=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
Date: Sat, 16 Apr 2011 16:26:03 +0800
Message-ID: <BANLkTinn8xfyFArd4Q9aA5N47BoZ_rgCxw@mail.gmail.com>
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

On Thu, Apr 14, 2011 at 3:13 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I'm writing a script to automatise some parts of my kernel compilation process.
>
> From those scripts I'd like to be able to call the top makefile the
> same way it had been called during its last invocation.
>
> For example, if Ido:
>
>     $ make CC=my-gcc CFLAGS="-g -fwhatever"
>
> I would like to retrieve the "CC=my-gcc CFLAGS="-g -fwhatever" part of
> the last invocation so my script can call make with the same
> arguments.
>

So why not just put that line into your script?

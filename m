Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1DPOAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:00:22 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:40210 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1DPOAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YfDEQy7JcpZmWR1oY9mr24D9UznZ+z1duU9A0NbVSCJFR/KB0Smu7lmMwep2z+jyTH
         2Vq+A9dJrwOEWUAaMwS2ebiQE4nvO7u77hqbfaeIhLusjxqypPMHwsHwwleyNZZjsM1O
         budBU5r4QFwFrXagI/6Oy6RtbSQm+w6zbwZWs=
MIME-Version: 1.0
In-Reply-To: <BANLkTinn8xfyFArd4Q9aA5N47BoZ_rgCxw@mail.gmail.com>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
	<BANLkTinn8xfyFArd4Q9aA5N47BoZ_rgCxw@mail.gmail.com>
Date: Sat, 16 Apr 2011 16:00:16 +0200
Message-ID: <BANLkTinMh7bofvSNW0gEoqaKvs27-xDGpQ@mail.gmail.com>
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

On Sat, Apr 16, 2011 at 10:26 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Apr 14, 2011 at 3:13 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>> Hello,
>>
>> I'm writing a script to automatise some parts of my kernel compilation process.
>>
>> From those scripts I'd like to be able to call the top makefile the
>> same way it had been called during its last invocation.
>>
>> For example, if Ido:
>>
>>     $ make CC=my-gcc CFLAGS="-g -fwhatever"
>>
>> I would like to retrieve the "CC=my-gcc CFLAGS="-g -fwhatever" part of
>> the last invocation so my script can call make with the same
>> arguments.
>>
>
> So why not just put that line into your script?
>

Because this line was an _example_ of how the makefile could had been invoked.

But the script has currently no idea how the previous invocation was
made, hence my question.

Thanks
-- 
Francis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab1ERQC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:02:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54966 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab1ERQC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q1U8YatGR5V/0Yu5NuBvOdElp4orBQU2T3GxhP6I+1+nI1dNmaXSnH8wceuK9nnPHg
         Mj8ftUECgDIi8Pkka66ftHER69IxUUmUxRBYlENmjWfz1MTM9NqIbLxfAO7dbYsM5NwZ
         PQYRlkKPQ2XtLttHHNZcnR4gbiaiL24OCs2gY=
MIME-Version: 1.0
In-Reply-To: <1305734101_6569@mail4.comsite.net>
References: <201105181637.46164.stevie.trujillo@gmail.com>
	<1305734101_6569@mail4.comsite.net>
Date: Thu, 19 May 2011 00:02:55 +0800
Message-ID: <BANLkTinQQwwgPGsX0YSpWJXN5oaatd1Q5g@mail.gmail.com>
Subject: Re: How to get backtrace? modprobe -r iwlagn; modprobe iwlagn kills kernel
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Milton Miller <miltonm@bga.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:55 PM, Milton Miller <miltonm@bga.com> wrote:
> On Wed May 18 2011 about 10:37:54 EST, Stevie Trujillo wrote:
>> I'm having some problem getting a backtrace. When I do "modprobe -r
>> iwlagn; modprobe iwlagn" (2.6.38.6 with Intel-1030N) the kernel crashes
>> (sometimes I need to try 2 or 3 times, and sometimes the modprobe -r
>> is the one that crashes).
>>
>> This spams my monitor with several oops/panics before it finally
>> dies. I can only see bottom of the last one, which probably isn't
>> very meaningful.  I tried loading netconsole, but I only get one or
>> two lines before it stops sending/printing.
>>
>> I then tried kexec+crashkernel, but I only managed to get a backtrace
>> for the last panic (which I think is just a result of memory corruption
>> or something).  Finally I tried compiling ramoops into my kernel,
>> but it didn't want to load because of "No such device".
>
> For the kexec+crashkernel, try to retrieve the kernel log buffer:
>

There is a utility in kexec-tools, named vmcore-dmesg, which
is supposed to do this kind of thing.

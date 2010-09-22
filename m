Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0IVNKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 09:10:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58707 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0IVNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 09:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=f+0F2MrMs4fJiiz/Z8Qi/MCLFKH0tkZg2bMpFkjfHp7rW5Jb0zXowAQr06C/0p2vGJ
         Iy4e7XrTUEyAEMJkaWE9OpX4XNpW6QWGk+hgYUYzS1Ql5Gvkz4fflvpdGp4vy366V8KG
         upK1skwsskCUeppAx2Lw8UQDTc5cmbQ5lpzlc=
MIME-Version: 1.0
In-Reply-To: <fdf800a16e7e44f19a684d4a4bf67288.squirrel@www.firstfloor.org>
References: <20100922090336.GA5338@basil.fritz.box>
	<AANLkTimqa1++9kNcODikTVMOExhypX6+kY_m7dCKb=64@mail.gmail.com>
	<fdf800a16e7e44f19a684d4a4bf67288.squirrel@www.firstfloor.org>
Date: Wed, 22 Sep 2010 15:10:04 +0200
X-Google-Sender-Auth: -qGT5AQNcPLCEhSrgO5ajfoRpIQ
Message-ID: <AANLkTimqTva4gYncxzeMokT19rYqZ4kj5p=jONYXmP7Q@mail.gmail.com>
Subject: Re: [PATCH] perf build fixes for opensuse 10.0
From: John Kacur <jkacur@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 1:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> On Wed, Sep 22, 2010 at 11:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>> Fix the perf Makefile to compile on opensuse 10.0
>>>
>>> -Werror in shipping code is usually a bad idea. Remove that.
>>
>> Why not remove it then when you ship the code, but leave it in the kernel
>> where it is useful?
>
> What do you mean with "you ship"?

The subject of your email is "perf build fixes for opensuse 10.0"
So, I inferred from there.

> I downloaded a kernel from kernel.org, it shipped to me and didn't
> build.

Any reason you can't fix the build errors instead?
Btw, I just tried building the lastest perf in tip/master
and I had no problems.

>
> People can enable -Werror in their private source dirs, but
> it shouldn't be in any downloadable tarball or git.
>

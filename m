Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0LaVzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 16:55:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32786 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0LaVzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 16:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=HLS3nkpQk7MQDJxpwMkYWZnR2jhS6sMM4++xHgo8oHqq6D6RGB5D7iMo/mZan2Frrb
         Ol0cPwnJLsTVXhZJd20BN0zjtYLL9uPWqRKnWYW5iEB3tKtn+5Cc2yQpB8pxE1T0na7r
         0tsbbcQ1XfR4Il2Qb3G4DHuj7jiNWL1m2NEmY=
MIME-Version: 1.0
In-Reply-To: <20101231234010.0165f0e8@janini.home>
References: <20101231193858.2c742025@janini.home> <20101231103345.baba0f8c.rdunlap@xenotime.net>
 <20101231212800.1e47f200@janini.home> <20101231113954.dc9adbdf.rdunlap@xenotime.net>
 <20101231234010.0165f0e8@janini.home>
From: Avery Pennarun <apenwarr@alumnit.ca>
Date: Fri, 31 Dec 2010 13:54:59 -0800
X-Google-Sender-Auth: 2AWLlRwl8KktiYYD8faEXNXu5js
Message-ID: <AANLkTi=GY+ZFNMCdCQAj7aL6smUmiJZ=a-kcc76EECj7@mail.gmail.com>
Subject: Re: APM_CONFIG on x86 - Is it possible?
To: yotam.medini@gmail.com
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 1:40 PM, Yotam Medini <yotam.medini@gmail.com> wrote:
> For a target ancient UMAX-ActionBook 530T, I am trying to compile
...
> The .config I ended up with does have:
>   CONFIG_APM=m
> But no CONFIG_APM_POWER setting,

I don't think CONFIG_APM_POWER does what you think it does.  I don't
know exactly what it does, either, but if you just want to use native
apm on your machine, you don't need it.

> When booting the kernel, I do not have /proc/apm.

Well, you compiled it as a module, so it's not surprising that it
wouldn't show up at boot time.

> I do get:
>
>  $ sudo modprobe apm
>  FATAL: Error inserting apm
>    (/lib/modules/2.6.32.yumax/kernel/arch/x86/kernel/apm.ko): No such device

The output of 'dmesg' might be revealing here.  However, it's likely
that your PC doesn't actually support APM unless it's *very* old.  You
might want to try ACPI instead.

Hope this helps.

Avery

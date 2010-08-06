Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482Ab0HFPBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:01:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55085 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab0HFPBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nILZ4V/QhNfabgDf0UKHCmIsXS1I1OhzQbKpcWnxKYnnzUHdrSy8JaxVYKoST+phf4
         wo8Zl1P3urw7MsZIqF9SZoT59Bd6intk8iOoElNfrtqfsqIuKPdHXDAoGyJziA/E+92V
         DAPfyM+6i0KOrao5HYQObGRMxmjIX3uN4pnVE=
MIME-Version: 1.0
In-Reply-To: <20100806121630.GA3024@DSH>
References: <20100806121630.GA3024@DSH>
Date: Fri, 6 Aug 2010 10:01:16 -0500
Message-ID: <AANLkTi=xfRAC4PqYVBnE7Fb8AzxmXLEe3rQW3kWiXm1v@mail.gmail.com>
Subject: Re: Hello, newbie wants help.
From: Victor Rodriguez <vm.rod25@gmail.com>
To: dingshaoheng <dshbusiness@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/6 dingshaoheng <dshbusiness@gmail.com>:
> Hello, all.
>
> I have used linux(ubuntu) for more than one year.
> For long time, I wish I can hack in the kernel.
> But I still can't fix a bug or write a driver, except compile the kernel.
> I really need some suggestion.
> Now, I'm reading some book--
>        Linux kernel development, second edition, by Robert Love.
>        Linux device driver, third edition, by Jonatban Corbet etc.
>
> But I find these books is so difficult to understand.
> The author always gave out new things that he has never explained.
> I wish if there is some way to learn the kernel step by step, or less hard.
> Could anyone give me some advice?
>
> PS: I have tried to read the source code, but they are even more difficult.
> I wish this email has been posted to the right place(not disturb you).
> I know you are busy coding. If this email is not appropriately, please do't
> be angry, just ignore it.
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Do not worry I think that  everyone should had been new in linux ones.
If i understand you want to learn how fix a bug and wtitea  driver, ok
look these are some links that i found interesting last mount when i
started to learn linux.

For the newwbies just likeus there is a web page

http://kernelnewbies.org

there you could check the all that you need

Take a look to

The Linux Kernel Module Programming Guide

http://www.tldp.org/LDP/lkmpg/2.6/html/index.html

and try to make your own hello word in Kernel Module
try to make a char driver and to make a procfs program
than and your procfs module to your OS and used it latter

this is a really good web page in order to see how to use you char
driver to turn on a led in your parallel port for example ( this is a
really good device driver example ) : )

http://www.freesoftwaremagazine.com/articles/drivers_linux?page=0%2C0

Then if you want to test your sistem make the TODO from kernel
janitors it is a really good beginning

it will take you a long time to do all the steps , but it will help
you to test your kernel with the Linux Test Project for example or
running a random config when you compile your kernel .


http://code.google.com/p/kernel-janitors/wiki/TODO


To understand linux check this

http://www.linuxfromscratch.org/

and learn the more that you can about C you will need it

a really good book is

C Programming Language (2nd Edition) from Kernigan and Ritchie

I hope it helps you It helps me

Sincerely yours

Victor Rodriguez

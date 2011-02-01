Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab1BAFPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 00:15:19 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46254 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1BAFPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 00:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SudI/tPajY5QkYz4yMVXajN5ZREdz6n8F8oClxoMC9mnhG3haumSC/ppKJ7OrKDBqP
         cTtMM8i+PnN0CzO2g5t0v9WSYP5dzTe6UFZdj29kiTwTOQRhTCFlLBGvPpzhMkxHwd4p
         j0rr2xL4bKLjX7nTDlE8Gt9httOOWBBw6n1sw=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4WQreo35jGLMQA16u+R-Ed036B3okrrx2nBGy@mail.gmail.com>
References: <AANLkTik4WQreo35jGLMQA16u+R-Ed036B3okrrx2nBGy@mail.gmail.com>
Date: Tue, 1 Feb 2011 10:45:16 +0530
Message-ID: <AANLkTinKnHs=oV+7wJdSZcNHTyMmWgPiEev6bBmL==R9@mail.gmail.com>
Subject: Re: what is spinlock depth
From: Rajat Sharma <fs.rajat@gmail.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep finds out dependency in locking order at runtime. More on this
in kernel documentation linux/Documentation/lockdep-design.txt

Rajat

On Tue, Feb 1, 2011 at 1:57 AM, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
> Hi all,
>
> I am reading spinlock code and looking at struct raw_spinlock. I found
> struct lockdep_map as member.
> which is defined as
>
> struct lockdep_map {
>       struct lock_class_key           *key;
>       struct lock_class               *class_cache[NR_LOCKDEP_CACHING_CLASSES];
>       const char                      *name;
> #ifdef CONFIG_LOCK_STAT
>       int                             cpu;
>      unsigned long                   ip;
> #endif
> };
>
> Can anyone help me explain, how this struct helps the spinlock. Why do
> we need lockdepth.
> Thanks for help in advance.
> --
> Regards,
> Sri.
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>

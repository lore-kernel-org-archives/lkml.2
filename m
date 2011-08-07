Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1HGRcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:32:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50202 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1HGRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAC-yRPQS7r-MMh13Y1m0O+oLBu2OmQqmXS8iHFtCOS9YwrxrkA@mail.gmail.com>
References: <CAC-yRPQS7r-MMh13Y1m0O+oLBu2OmQqmXS8iHFtCOS9YwrxrkA@mail.gmail.com>
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Sun, 7 Aug 2011 22:02:02 +0430
Message-ID: <CAC-yRPSrMzbofnpooFgzxd=WyeTPHVsiaL195ZPKD-ndeMRdzg@mail.gmail.com>
Subject: Re: Compile kernel for various times and problem of too long time consuming
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is very urgent for me to find my question's answer soon.
Your help is appreciated:)

On Sun, Aug 7, 2011 at 9:39 PM, Amirali Shambayati
<amirali.shambayati@gmail.com> wrote:
> Hi all,
> Since I want to evaluate performance improvements by changing just one
> file in kernel(noop-iosched) and compiling kernel is too much
> time-consuming, I want to know that if I compile kernel for more than
> one time, does it take similar time to first time?
>
> I use following commands. If I don't use "make-kpkg clean" for next
> times, does it just compile the files which have been modified or it
> compile whole kernel package again?
>
> make-kpkg clean
> fakeroot make-kpkg --initrd --append-to-version=-some-string-here
> kernel-image kernel-headers
>
>
> Thanks for your help in advance,
>
> --
> Amirali Shambayati
> Bachelor Student
> Computer Engineering Department
> Sharif University of Technology
> Tehran, Iran
>



-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran

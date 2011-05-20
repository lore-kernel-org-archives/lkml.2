Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935415Ab1ETJCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:02:37 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55614 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934735Ab1ETJCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ImG0D8by4FqmkuwWrEI4AJhNs3D2hY2rmjnCBP/eWnYC35A64SsNCPmOSlRQLJTXgk
         wx+whHiGiMspKerINQjSm/ZW67+Sp3+IwiD5Qw7BUOneD1Gh8h8rXOp0xMMiiUEHfVmq
         bL/mR+WNiy8T9owd4JGFdzuPSXNn/6alNKO8M=
MIME-Version: 1.0
In-Reply-To: <201105201058.20355.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
	<BANLkTikCS=LbvXSe4ok740O2ue1DQDfBmA@mail.gmail.com>
	<201105201058.20355.toralf.foerster@gmx.de>
Date: Fri, 20 May 2011 11:02:35 +0200
Message-ID: <BANLkTim6yqMipB37Q=OJg=aC89vumCVewg@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Toralf Förster <toralf.foerster@gmx.de>:
>> Ick, I meant "objdump -d -S vmlinux | less"
> Well (BTW nearly similar to the result of "objdump -d -S linux" ), but anyway
> here it is :

I hope it's _exactly_ the same result. vmlinux and linux are hard linked...

-- 
Thanks,
//richard

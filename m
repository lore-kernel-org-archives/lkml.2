Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935157Ab1ETIjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:39:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59761 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934797Ab1ETIjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FZDurfN8JP21eqz8weM+KdvR8xiDRhRQk1wh08OTcU3gakaZ+sT44bmPgq83eo8Ult
         FFYu1tpDJTyNMh54lJwLzs/myqL2/PjklmrgjYEO3C0VY2X/OPxgW9ZSWKaQbhd2a/Mb
         qJFLOb9H9VCFsY12gaYSho5WD8BW0AUpCZtnY=
MIME-Version: 1.0
In-Reply-To: <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<201105192218.18261.toralf.foerster@gmx.de>
	<20110519204342.GA10792@home.goodmis.org>
	<201105200937.15322.toralf.foerster@gmx.de>
	<BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
Date: Fri, 20 May 2011 10:39:03 +0200
Message-ID: <BANLkTikCS=LbvXSe4ok740O2ue1DQDfBmA@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 richard -rw- weinberger <richard.weinberger@gmail.com>:
> Use "objdump -d -S | less" to find it.

Ick, I meant "objdump -d -S vmlinux | less"

-- 
Thanks,
//richard

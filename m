Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0HXDsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:48:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49852 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0HXDsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xfU+OCLU9S2I6ZQW76kkFcCFq/upQ69y1eDE3Vd32di8l2bInwk+/Q8psnKPPoLdA4
         K5AWyeS0cOFmravNHmRWyQ78KfMuohwrcO0zr5wzHJzam7orJw2UdVze4fsuWnAQW6b3
         bwocNZnBLES5D6X1xETdPPyY7gc5jK1x3TCN4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.30.1008232025260.31237-100000@mail.perches.com>
References: <0F1B54C89D5F954D8535DB252AF412FA06C35A09@chinexm1.ad.analog.com> <Pine.LNX.4.30.1008232025260.31237-100000@mail.perches.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 23 Aug 2010 23:47:53 -0400
Message-ID: <AANLkTin6jwj0Eo4fDm3Tm3Jp6er+G8t_ioQU6GiBjtu5@mail.gmail.com>
Subject: Re: [PATCH 2/2] drivers/serial/bfin_5xx.c: Use pr_<level> and pr_<fmt>
To: Joe Perches <joe@perches.com>
Cc: "Zhang, Sonic" <Sonic.Zhang@analog.com>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 23:30, Joe Perches wrote:
> On Tue, 24 Aug 2010, Zhang, Sonic wrote:
>> >Also fix typo of length.
>> >Signed-off-by: Joe Perches <joe@perches.com>
>> >-            pr_info("Unable to attach BlackFin UART Modem "
>> >-                    "Status interrupt.\n");
>> >+            pr_info("Unable to attach BlackFin UART Modem
>> >Status interrupt\n");
>> I don't this this change is necessary.
>
> Linus once said he doesn't like splitting
> format lines because it makes grep more
> difficult.
>
> http://lkml.org/lkml/2009/12/17/229

ah, i hadnt realized sanity had come to town.  this was one of my
largest gripes about string splitting ... having to figure out the
magic variation in substrings for grep to find a match.
-mike

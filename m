Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2FJMiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 08:38:01 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38370 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439Ab2FJMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 08:38:00 -0400
MIME-Version: 1.0
In-Reply-To: <4FD48744.3000602@free.fr>
References: <4FD4837B.5040200@free.fr>
	<20120610123420.52af4e1a@pyramind.ukuu.org.uk>
	<4FD48744.3000602@free.fr>
Date: Sun, 10 Jun 2012 14:37:58 +0200
Message-ID: <CAFLxGvwtCDCdWoXCBr2nytm93Kyei-pLoioGGxhu_+TMFfdNzQ@mail.gmail.com>
Subject: Re: Linux 3.2.19 kernel panic does not enter KDB
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: eric.valette@free.fr
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 1:38 PM, Eric Valette <eric.valette@free.fr> wrote:
> On 10/06/2012 13:34, Alan Cox wrote:
>
>>
>> I think you are on the wrong list. Nvidia have kernel source code, we
>> don't have code to their proprietary stuff. Only they can help you.
>>
>> It's quite possible the box is hanging so hard that kdb can't help you.
>> In that case you'll again need someone with their proprietary Nvidia
>> source to help you.
>
>
> Maybe you are still annoyed by the picture linus has posted but that type of
> answer helps nothing. I know nobody there is going to debug nvidia driver
> but I'm not even sure its not something else. Neither are you.
>
> So the bug is still that KDB is not entered.

The problem with proprietary code is that *anything* can happen.
If the crash happened within the Nvidia binary blob you are toasted...

-- 
Thanks,
//richard

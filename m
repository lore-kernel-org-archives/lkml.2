Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab0FKMxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:53:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55433 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab0FKMxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <20100611131652.053afebd@lxorguk.ukuu.org.uk>
References: <AANLkTil0M_2aiRX5IoMzC90O9WgzJPco3arHmDSG_44H@mail.gmail.com>
	<20100611131652.053afebd@lxorguk.ukuu.org.uk>
Date: Fri, 11 Jun 2010 14:53:50 +0200
Message-ID: <AANLkTilPJYVbAJEEUMInaB9R4fUPPvq_pS3PdROpifIp@mail.gmail.com>
Subject: Re: Hardcore trashing without any swap
From: =?UTF-8?B?TMOhc3psw7MgTW9uZGE=?= <laci@monda.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 2:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 11 Jun 2010 02:10:33 +0200
> László Monda <laci@monda.hu> wrote:
>
>> Hi List,
>>
>> The problem I'm facing with is very simple, yet extremely irritating
>> in nature.  I have a laptop with 4G RAM and I don't use any swap.
>> Whenever the RAM is full my system keeps trashing.  This makes X and
>> SSH completely unresponsive for about a hour then a bunch of processes
>> gets killed and it's usable again.
>>
>> How is possible that my system is trashing even though I don't use any swap?
>
> Because you don't have any swap. Its having to dump stuff it doesn't want
> to like bits of applications that it can retrieve back from disk.

I can read what you wrote but cannot really understand it.  Please
tell me where my logic fails:

No swap -> no dedicated space on disk to dump stuff -> no disk I/O
should happen at all

>> I'd expect the kernel to immediately kill the largest process without
>> any trashing so I could continue my work right after the event.  How
>> is it possible to configure?
>
> It isn't.
>
> However if you want to avoid overcommit and thrashing play with
>
> /proc/sys/vm/overcommit*
>



-- 
László Monda <http://monda.hu>

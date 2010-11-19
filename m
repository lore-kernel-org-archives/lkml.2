Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0KSSfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:35:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61885 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0KSSfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:35:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OpAOTBP+sYME6RMfDQd36z1p0imgpD7SVfnsSZ/Bw8wHCEr6AUK/FG+DMYLinjxirJ
         so/Ao1jZz4jsMx+69S7TTirAuc01/1TjqKHBT4/C6FNNZwkrRhuVNQQZjzwWVzOHc1I6
         dyAJWcyfxpxzunqFoLhQId5XeltyMgzE6SkCI=
MIME-Version: 1.0
In-Reply-To: <20101119174257.58bb8e32@lxorguk.ukuu.org.uk>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
	<AANLkTik6Aq+kWzpmYckKkV5yVMFPt-J0E7OMM6Rd4ouO@mail.gmail.com>
	<20101119174257.58bb8e32@lxorguk.ukuu.org.uk>
Date: Fri, 19 Nov 2010 19:35:05 +0100
Message-ID: <AANLkTimC51Rb+7eMGYoJ9biGS1Tp1wPC-Ujg55fkOvHR@mail.gmail.com>
Subject: Re: linux-next: Tree for November 19
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/19 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Fri, 19 Nov 2010 18:40:41 +0100
> Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:
>
>> Salve,
>>
>> 2010/11/19 Stephen Rothwell <sfr@canb.auug.org.au>:
>> > Hi all,
>> >
>> > Changes since 20101118:
>>
>> This probably should not be available on x86_64
>>
>>   BLD FW  drivers/net/wan/wanxlfw.inc
>> /bin/sh: as68k: command not found
>> /home/test/linux-2.6/drivers/net/wan/wanxlfw.S:39:0: fatal error: when
>> writing output to : Broken pipe
>> compilation terminated.
>> make[4]: *** [drivers/net/wan/wanxlfw.inc] Error 127
>
> If you want to build the wanxl firmware then you need the m68k assembler
> for the firmware, so it is right.
>

Ok, thanks for the info.

I'll try to find souces for this asm and install it to avoid future
failed builds.

-- 
Slawa!
N.P.S.

Chwa³a tobie, Szatanie, cze¶æ na wysoko¶ciach
Nieba, gdzie królowa³e¶, chwa³a w g³êboko¶ciach
Piek³a, gdzie zwyciê¿ony, trwasz w dumnym milczeniu!
Uczyñ, niechaj ma dusza spocznie z Tob± w cieniu
Drzewa Wiedzy, gdy swoje konary rozwinie,
Jak sklepienie ko¶cio³a, który nie przeminie!

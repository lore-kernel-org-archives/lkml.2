Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1EGKKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 06:10:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46709 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1EGKKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 06:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VvBoHsAoCqpgitfn2vyjhHAQtzG09g137kuofpkUB5W1s3RWE6xxsSh/tZPdPiSRWE
         2ihRM9amu4LvllyIIns8FP2JFpfTxkk1iGn10KHoz+HCk3NfRbOfqqnXTwiehYznJPyb
         VY1XWBg09S1zcHirazIjUtnMUBEs0i4meeVYQ=
MIME-Version: 1.0
In-Reply-To: <1304749754.2821.712.camel@edumazet-laptop>
References: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com>
 <1304748394.2821.654.camel@edumazet-laptop> <BANLkTi=tZf1uQig8A-WiXUpSWcuqaqV=fg@mail.gmail.com>
 <1304749754.2821.712.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 7 May 2011 18:10:23 +0800
Message-ID: <BANLkTimMAhp42bWsogL49W7LqOLzAsiaig@mail.gmail.com>
Subject: Re: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 2:29 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 07 mai 2011 à 14:22 +0800, Changli Gao a écrit :
>
>> It seems more clear. Thanks.
>>
>> BTW: I will work on F_CLOSFD after this patch accepted. It is useful
>> to close all the opened file descriptors when programing a daemon.
>>
>
> I am sure the following idea already was discussed in the past :
>
> Embed the close_on_exec / close_on_close bits in the low order bits of
> file pointers.
>
> Might be interesting to raise it again.
>
>

Excellent idea! Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)

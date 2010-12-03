Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0LCTha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 14:37:30 -0500
Received: from mail.asbjorn.biz ([217.195.185.3]:54083 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab0LCTh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 14:37:28 -0500
Message-ID: <4CF946F5.6040103@asbjorn.biz>
Date: Fri, 03 Dec 2010 19:37:25 +0000
From: =?UTF-8?B?QXNiasO4cm4gU2xvdGggVMO4bm5lc2Vu?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: support overriding userland architecture
References: <4CD5A6C8.8030603@asbjorn.biz> <1289070320-20726-1-git-send-email-asbjorn@asbjorn.biz> <20101203174800.GA952@stro.at>
In-Reply-To: <20101203174800.GA952@stro.at>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

On 12/03/2010 05:48 PM, maximilian attems wrote:
> On Sat, 06 Nov 2010, Asbjoern Sloth Toennesen wrote:
>> Usefull if building for sparc64 userland, because the
>> sparc and sparc64 userlands use the same 64-bit kernel,
>> making it impossible to always select the correct userland
>> architecture for the resulting debian package.
>>
>> Might also be usefull, if you want a i386 userland with a amd64 kernel.
>>
>> Example usage:
>> 	make DEBARCH=i386 deb-pkg
>>
>> This patch is based on my 'kbuild, deb-pkg: select
>> userland architecture based on UTS_MACHINE' patch.
>
> care to repost with KBUILD_ prefix, to keep namespace sane and mention
> in  Documentation/kbuild/kbuild.txt together with the relevant acks.
> It be really cool to have that in next 2.6.38.

Sure its on my todo for the weekend, have just had an insane week.

I just noticed the armhf port effort yesterday, that would also need
this patch, I will add your Ack-by when sending the updated patch.

I also have a bunch of e1000e cleanups scheduled for 2.6.38, will submit
to netdev this weekend as well.

Thanks, for the reminding effort.

-- 
Best regards
Asbjørn Sloth Tønnesen
asbjorn.biz

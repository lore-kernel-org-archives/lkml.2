Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0LIPmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:42:11 -0500
Received: from mail.asbjorn.biz ([217.195.185.3]:60033 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab0LIPmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:42:09 -0500
Message-ID: <4D00F8CF.7010907@asbjorn.biz>
Date: Thu, 09 Dec 2010 15:42:07 +0000
From: =?UTF-8?B?QXNiasO4cm4gU2xvdGggVMO4bm5lc2Vu?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH v3] kbuild, deb-pkg: support overriding userland architecture
References: <4D00F473.9090009@asbjorn.biz> <1291908254-19468-1-git-send-email-asbjorn@asbjorn.biz> <4D00F709.1000406@suse.cz>
In-Reply-To: <4D00F709.1000406@suse.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 03:34 PM, Michal Marek wrote:
> On 9.12.2010 16:24, Asbjoern Sloth Toennesen wrote:
>> Usefull if building for sparc64 userland, because the
>> sparc and sparc64 userlands use the same 64-bit kernel,
>> making it impossible to always select the correct userland
>> architecture for the resulting debian package.
>>
>> Might also be usefull, if you want a i386 userland with a amd64 kernel.
>>
>> Example usage:
>> 	make KBUILD_DEBARCH=i386 deb-pkg
>>
>> LKML-reference: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
>> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
>> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
>> Acked-by: maximilian attems <max@stro.at>
>> ---
>>  Documentation/kbuild/kbuild.txt |    8 ++++++++
>>  scripts/package/builddeb        |    3 +++
>>  2 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
>> index 634c625..9cf3bf0 100644
>> --- a/Documentation/kbuild/kbuild.txt
>> +++ b/Documentation/kbuild/kbuild.txt
>> @@ -60,6 +60,14 @@ But some architectures such as x86 and sparc have aliases.
>>  x86: i386 for 32 bit, x86_64 for 64 bit
>>  sparc: sparc for 32 bit, sparc64 for 64 bit
>>  
>> +KBUILD_DEBARCH
>> +--------------------------------------------------
>> +For the deb-pkg target, allows overriding the normal heuristics deployed by
>> +deb-deb. Normally deb-pkg attempts to guess the right architecture based on
>    ^^^^^^^
> 
> deb-pkg?

Sure. Anything else before I make a v4?

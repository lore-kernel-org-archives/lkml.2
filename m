Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0LIPXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:23:34 -0500
Received: from mail.asbjorn.biz ([217.195.185.3]:42609 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab0LIPXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:23:33 -0500
Message-ID: <4D00F473.9090009@asbjorn.biz>
Date: Thu, 09 Dec 2010 15:23:31 +0000
From: =?UTF-8?B?QXNiasO4cm4gU2xvdGggVMO4bm5lc2Vu?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH v2] kbuild, deb-pkg: support overriding userland	architecture
References: <20101125143739.GC8192@sepie.suse.cz> <1291844150-4541-1-git-send-email-asbjorn@asbjorn.biz> <20101209142447.GA12350@vostochny.stro.at>
In-Reply-To: <20101209142447.GA12350@vostochny.stro.at>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 02:24 PM, maximilian attems wrote:
> On Wed, Dec 08, 2010 at 09:35:50PM +0000, Asbjoern Sloth Toennesen wrote:
>> Usefull if building for sparc64 userland, because the
>> sparc and sparc64 userlands use the same 64-bit kernel,
>> making it impossible to always select the correct userland
>> architecture for the resulting debian package.
>>
>> Might also be usefull, if you want a i386 userland with a amd64 kernel.
>>
>> Example usage:
>> 	make DEBARCH=i386 deb-pkg
> 
> hmm the conclusion was to prepend a KBUILD_ prefix for a kbuild variable?
> Any reason why that was overlooked?
> 
> I checked man devscripts and saw yet no definition of DEBARCH, but in order
> not to have any potential conflicts and to keep namespase sane I think
> it is very much preferred to use KBUILD_DEBARCH.

Sorry, I forgot it, patch comming up.

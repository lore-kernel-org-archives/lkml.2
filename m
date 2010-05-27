Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0E0E1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:27:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51002 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0E0E1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CPFvUoaqnv4+nrFRIEihh5zNZVOiXGbSjqNORJb9osib2X5RSpqNpxWqhpQcOc4+dA
         FteMHiMElcK01oDV/hcs3ihCa2UALOqODiQahMtA1KpaFYcMpXHTCzLLSmx3mE9nJiOS
         GR6+V9MI/lfI276nxThiAKGyl9TEApUhSuU/U=
Date: Thu, 27 May 2010 12:31:23 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527043123.GA5349@cr0.nay.redhat.com>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
 <201005270213.42913.rjw@sisk.pl>
 <AANLkTil180tPW4KoOaUBgXIm1Lf6O45_GKKlLx3CDcVh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil180tPW4KoOaUBgXIm1Lf6O45_GKKlLx3CDcVh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 09:39:51AM +0530, Jaswinder Singh Rajput wrote:
>Hello Rafael,
>
>On Thu, May 27, 2010 at 5:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Thursday 27 May 2010, Jaswinder Singh Rajput wrote:
>>> Hello,
>>>
>>> I am trying to build 32 bit kernel image on 64-bit machine but after
>>> 'make menuconfig' it automatically switches 32-bit to 64-bit.
>>
>> Try 'linux32 make menuconfig' and 'linux32 make'.
>>
>
>Yes, this works :-)


I think 'make ARCH=i386 menuconfig' also works.

>
>But I wonder then what is the point/use of CONFIG_X86_32 if compiler
>is not listening to it.
>
>Logically compiler should set appropriate flags based on .config settings.
>

It's not compiler, it's kbuild, kbuild tries to determine the arch
by 'uname -m'.

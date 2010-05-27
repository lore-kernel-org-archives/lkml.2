Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab0E0I7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:59:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49215 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0E0I7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mynajdD7SYycDjuPZg96OzzRywjv1yEwZ1HOoXZ3kTt8/RVQpD33ioXHdfQVwqUil5
         gdhkoP2gWyfFdw3HPRW6oFysRdL/tJhy/ymQEc+6sBZbGjkXovnWDJOVu7ZLCA2uhpdZ
         x/h3Ive337AibBlMBQEGxOACR5k/pXVaKUTP8=
Date: Thu, 27 May 2010 17:03:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-ID: <20100527090329.GF5349@cr0.nay.redhat.com>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
 <201005270213.42913.rjw@sisk.pl>
 <AANLkTil180tPW4KoOaUBgXIm1Lf6O45_GKKlLx3CDcVh@mail.gmail.com>
 <20100527043123.GA5349@cr0.nay.redhat.com>
 <AANLkTilZ99VsmLuYoLlYItYAMtQQq6zTOQ2iEAdEm7pk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilZ99VsmLuYoLlYItYAMtQQq6zTOQ2iEAdEm7pk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:53:41AM +0530, Jaswinder Singh Rajput wrote:
>On Thu, May 27, 2010 at 10:01 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Thu, May 27, 2010 at 09:39:51AM +0530, Jaswinder Singh Rajput wrote:
>>>
>>>But I wonder then what is the point/use of CONFIG_X86_32 if compiler
>>>is not listening to it.
>>>
>>>Logically compiler should set appropriate flags based on .config settings.
>>>
>>
>> It's not compiler, it's kbuild, kbuild tries to determine the arch
>> by 'uname -m'.
>>
>
>Ahh, then kbuild is buggy, kbuild should check .config instead of
>'uname -m' and verify from user if it mismatches.
>

Why? You didn't use 'make oldconfig', why shoud it check?

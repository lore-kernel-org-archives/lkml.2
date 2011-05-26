Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab1EZSEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:04:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46268 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1EZSEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eVVBG0zL6urh3Vjnx/O7Xi7eDxKc5T8ESG4s8zvuDXt/ZjQpL94g/uGyLTpYU9di7w
         u8k8WnZXQodAlhXX7fqQJ16+uTPdOiHHfTP1iId8PRdo126Js3GAe+ACgoqeiEeBu9M/
         AVUyd58yXY7VmADntbwa5dglLcL8Gs1fjmSTU=
MIME-Version: 1.0
In-Reply-To: <BANLkTik8XZnQ7T4X=V3VPY6Ap9R+Xcm3iQ@mail.gmail.com>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-6-git-send-email-andi@firstfloor.org> <BANLkTimKjtns7oFNMTLbnbyAkKi679ui5A@mail.gmail.com>
 <BANLkTik8XZnQ7T4X=V3VPY6Ap9R+Xcm3iQ@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 26 May 2011 14:04:10 -0400
Message-ID: <BANLkTi=_tJMGkZOK6Pm6KtD6P7bwgbt3qQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] Hook up sysconf syscall for all architectures
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 21:46, Mike Frysinger wrote:
> On Fri, May 13, 2011 at 22:23, Mike Frysinger wrote:
>> On Fri, May 13, 2011 at 19:24, Andi Kleen wrote:
>>>  arch/blackfin/include/asm/unistd.h     |    3 ++-
>>>  arch/blackfin/mach-common/entry.S      |    1 +
>>
>> i wish more people would wire up new syscalls for arches ;)
>>
>> i dont recall off the top of my head acking any other pending new
>> syscall which would cause a conflict, so:
>> Acked-by: Mike Frysinger <vapier@gentoo.org>
>>
>> i generally wait for syscalls to hit mainline before i wire them up myself
>
> i'm wiring up sendmmsg on Blackfin systems and will be pushing in a
> day or two, so this will need a little tweaking after that hits
> mainline

ok, i lied about that.  i kept the patch local so that when your merge
goes through, there wont be any conflicts.  you are still planning on
pushing this for 2.6.40-rc1 right ?  if not, i'll just send out my
sendmmsg wiring now.
-mike

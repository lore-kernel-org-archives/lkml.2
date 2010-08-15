Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0HOHOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 03:14:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36489 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0HOHOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 03:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=HWhfm/sO9WucjpeFh3Z1/HTrBrSvxUInmx1QLKMUFX/LBxlWF+1O36KXtTiRdCBbTl
         6FlSKdFDt1nJpifs21xx+nEa9y5TspC7/HwAr9NLxl+V0WBTmx6Zu+jWTVASPqjykr3P
         P9q6dt5miyuinJYjiJcg28kSskpJbQGjJ7X24=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20100815011542.GA30094@merkur.ravnborg.org>
References: <AANLkTimYDzCowvmKgSDp0BJjLHadvtDgCVJkZgdAt4u7@mail.gmail.com>
	<20100815011542.GA30094@merkur.ravnborg.org>
Date: Sun, 15 Aug 2010 09:07:00 +0200
Message-ID: <AANLkTikCdd0jYfdhsOZE2mT8hqLfYop9qYRDCRo2TaaU@mail.gmail.com>
Subject: Re: [PATCH] kconfig: fix savedefconfig with choice marked optional
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 3:15 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Aug 15, 2010 at 01:26:22AM +0200, Sedat Dilek wrote:
>> Recent kbuild/kconfig patches seem not to be in
>> <http://repo.or.cz/w/linux-kbuild.git>?
>>
>> Looks like there is a new home:
>>
>> -T:      git git://repo.or.cz/linux-kbuild.git for-next
>> -T:      git git://repo.or.cz/linux-kbuild.git for-linus
>> +T:      git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
>> for-next
>> +T:      git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
>> for-linus
>
> This is already fixed in upstream. You need to update
> your source repository.
>
> See: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3631d9a2e503ec9c36b0599b2e45548e5c410516
>

I am sorry, did not look into the patched src-dir:

$ grep kbuild debian/build/source_i386_none/MAINTAINERS | grep ^T
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
for-next
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git
rc-fixes

Thanks!

- Sedat -

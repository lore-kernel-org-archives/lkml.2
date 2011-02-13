Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1BMVKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 16:10:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36263 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab1BMVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 16:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nKIK7YEF72CrewVmGRjyQDVStK6FZpBdg/w3ZqyceAYJdxHjcS+CzIicXnvsMU/IQK
         kUMIpTiKNJdlLixoVPrP3AhgDA1pTni/0io2MBKuLTvQrsuHDSQYPNjW65aSqN+Zlsmc
         4qnbdDzFdCfZelzaMXCEya8jPMbbVT44+LgI4=
MIME-Version: 1.0
In-Reply-To: <201102132110.29630.arnd@arndb.de>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<201102132110.29630.arnd@arndb.de>
Date: Sun, 13 Feb 2011 13:10:19 -0800
Message-ID: <AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 12:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 12 February 2011 20:41:01 H.J. Lu wrote:
>> Hi,
>>
>> We made lots of progresses on x32 pABI:
>>
>> https://sites.google.com/site/x32abi/
>>
>> 1. Kernel interface with syscall is close to be finalized.
>
> Really? I haven't seen this being posted for review yet ;-)
>
> The basic concept looks entirely reasonable to me, but I'm
> curious what drove the decision to start out with the x86_64
> system calls instead of the generic ones.
>
> Since tile was merged, we now have support for compat syscalls
> in the generic syscall ABI. I would have assumed that it
> was possible to just use those if you decide to do a new
> ABI in the first place.
>
> The other option that would have appeared natural to me is
> to just use the existing 32 bit compat ABI with the few
> necessary changes done based on the personality.
>

If you are interested, please check out the x32 kernel to
take a look and provide feedback.

Thanks.

-- 
H.J.

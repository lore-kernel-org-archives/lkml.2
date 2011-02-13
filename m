Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1BMNp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 08:45:27 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34583 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1BMNpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 08:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OjbbuWCTdXTAighKRPzBV6qLSlfYiex1zn7pJ4pVqU6Kqb2ZfkN9FGbyzMwOPSQRE4
         IPA6NABrEzS46yP7jKRe1LBi7mpPZ9T2xm4cn69hFurysfBI0QskFTHQcajYy0vGb7Hk
         tb0zxigL3NZoW9LxyU5SxHe5pwnsRNzMuucJE=
MIME-Version: 1.0
In-Reply-To: <87r5bcnwvw.fsf@mid.deneb.enyo.de>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de>
	<4D5711E0.7020306@zytor.com>
	<87r5bcnwvw.fsf@mid.deneb.enyo.de>
Date: Sun, 13 Feb 2011 05:45:21 -0800
Message-ID: <AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: x32-abi@googlegroups.com, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 12:48 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * H. Peter Anvin:
>
>> On 02/12/2011 01:10 PM, Florian Weimer wrote:
>>> Why is the ia32 compatiblity kernel interface used?
>>
>> Because there is no way in hell we're designing in a second
>> compatibility ABI in the kernel (and it has to be a compatibility ABI,
>> because of the pointer size difference.)
>
> Actually, I'm wondering if you can do the translation in user space.
> There already are 32-on-64 implementations in existence, without
> kernel changes (recent Hotspot, LuaJIT, and probably some more).

Please check out the x32 kernel source and provide feedback.

-- 
H.J.

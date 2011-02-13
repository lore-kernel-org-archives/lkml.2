Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1BMDCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 22:02:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39463 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1BMDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 22:02:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mYZ/Rfk/JHofuSU3tDHWNBSqC61NAcJe+56UQW3NJ7658wCl7S78ZaT7s8CS3Ce/1G
         q0Lp6bTqTWu7McmaLf4O9rhgY166oIJdo42haPVNHjW5pQ2942sPSfiJBuEXT+mVDnoW
         kqi+Hw2dOdWRfY1qAFndJnEUWETkxP4ZveY0M=
MIME-Version: 1.0
In-Reply-To: <4D5711E0.7020306@zytor.com>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de>
	<4D5711E0.7020306@zytor.com>
Date: Sat, 12 Feb 2011 19:02:03 -0800
Message-ID: <AANLkTin3YT65gV-k620JUimgDYQLwSySGHUck5u7pT0c@mail.gmail.com>
Subject: Re: X32 psABI status
From: Andrew Pinski <pinskia@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x32-abi@googlegroups.com, Florian Weimer <fw@deneb.enyo.de>,
        "H.J. Lu" <hjl.tools@gmail.com>, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 3:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/12/2011 01:10 PM, Florian Weimer wrote:
>> Why is the ia32 compatiblity kernel interface used?
>
> Because there is no way in hell we're designing in a second
> compatibility ABI in the kernel (and it has to be a compatibility ABI,
> because of the pointer size difference.)

I think he is asking why not create a new ABI layer for the kernel
like it is done for n32 for MIPS.

-- Andrew

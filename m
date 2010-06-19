Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0FSMjI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:39:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60568 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab0FSMjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=GwxC3QBl7JVAXfigi0GGesDNeZN5vg0DiKdC7Wgm1Bz4nAcK7ADm+XvpolWTMtjCDN
         g5Pits5uWT3wMWF2VMeMnvc4vszMTa4yEvEANsaDUqXBsQvi/Y3Mn0ytu7KDPN9ZF8yI
         hML1urZNWpkZ5kS2t4CsewVQcAy4VxQL8JJRk=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100619122918.GJ18946@basil.fritz.box>
References: <AANLkTinX4TlNfvwrCtjfkU-bar3URnpvmPJB-sOi-9aT@mail.gmail.com> 
	<20100619085849.GD18946@basil.fritz.box> <AANLkTikNEECT9CgPuCKy0h1LVKfjdXM-lavzW-TnUTz-@mail.gmail.com> 
	<20100619122918.GJ18946@basil.fritz.box>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sat, 19 Jun 2010 14:38:42 +0200
Message-ID: <AANLkTimkOErPh0PF89LnitLaZhmVGH3cbhIw1cAcRT_p@mail.gmail.com>
Subject: Re: man-pages text for MAV_MERGEABLE and MADV_UNMERGEABLE
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh.dickins@tiscali.co.uk, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sat, Jun 19, 2010 at 2:29 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Jun 19, 2010 at 02:22:33PM +0200, Michael Kerrisk wrote:
>> Hi Andi,
>>
>> On Sat, Jun 19, 2010 at 10:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> +.IR len .
>> >> +The KSM daemon
>> >> +.RI ( ksmd )
>> >
>> > You should probably make clear it's a kernel thread, not a classic
>> > daemon.
>>
>> Thanks. I changed it to "KSM kernel thread"
>>
>> >> +periodically scans those areas of user memory that have
>> >> +been marked as mergeable,
>> >> +looking for pages with identical content.
>> >
>> > Overall it seems like an internal implementation detail.
>>
>> Not sure how I could improve this. Did you have some specific idea in mind?
>
> Just dropping the sentence or using soft language like "the kernel regularly
> attempts to merge pages"

Thanks. I reworded like as you suggest.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/

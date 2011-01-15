Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1AOLoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 06:44:22 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38415 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1AOLoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 06:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=hxXo+FvD2VBHVtIYbEWcqL6N81lh0uEuCBniyKJKt0G0xp9OsP5qEhI+8dssaHC4PN
         bThXtmPx4Qs8RWriN6ICUz6f6qVEm9F6TUqx+HaAx3UGXPJ7bDWukOQAsP4N/ccD2WW4
         fJSasjMGejqlzX7YIS8Hvo5QfWGUoo+17lgF8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110115113445.GM19804@ZenIV.linux.org.uk>
References: <AANLkTik4JfjBEurjX4T3sAtGf9CPJvQYkV5aZWgE=XD1@mail.gmail.com>
	<AANLkTin0SUG3Q3aHVfBqCV8=iWThy3MTfG90ikMsrox9@mail.gmail.com>
	<20110115075723.GJ19804@ZenIV.linux.org.uk>
	<20110115090702.GK19804@ZenIV.linux.org.uk>
	<AANLkTinPs5toSudLXuu3=a0RoGHUqYvF8YyhdrXgckXY@mail.gmail.com>
	<20110115110848.GL19804@ZenIV.linux.org.uk>
	<AANLkTinXPgfkcLq6LsQ=dsFZgQK5JG4f4GQW92r95J5C@mail.gmail.com>
	<20110115113445.GM19804@ZenIV.linux.org.uk>
Date: Sat, 15 Jan 2011 12:44:19 +0100
Message-ID: <AANLkTim3RoeW4bmNjcdC3-6Y-ngZpm9w2qaDFxHsP8=h@mail.gmail.com>
Subject: Re: linux-next: Tree for January 15 (Call Trace in fs/dcache.c + autofs4)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 12:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Jan 15, 2011 at 12:16:29PM +0100, Sedat Dilek wrote:
>
>> Which version do you mean by "mainline"? 2.6.37-git12?
>> And with "[mismerge][foldme] breakage in __do_follow_link()" patch [1]?
>> I have to look by pulling-in(to) Linus-tree (linux-next) which patches
>> are not merged already.
>
> -git12 would do.  Without any extra patches.  Can you reproduce the
> ext3 oops on that alone?
>

Just a short answer (on the go... weekend shopping)...
Currently, I am on a lame IBM T40p (Pentium-M) and doing a "full" build.
Unfortunately, I started a next linux-next build with the two patches
from vfs-2.6#for-next.
When I return I will try this kernel.
If things aren't OK, I do a mainline build afterwards (w/o any patches).

- Sedat -

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1DFMTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:19:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47857 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1DFMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=a5l5aAlGQCkVgh/6lub1mf7RabGkJwZRhWrHMtSBKvMBUrMw7KbICzq18JUrFZUhQv
         qAg4uxWDJoYawcVx+QK+T5YUIIOu+TQXsbsy0jOTAvINIv3YUFOAtHNbQ1nnS9Mb3Uvy
         oxLLuq0nG+UFtExMloj1MaBu1m1Wi/FIUItPo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110406152915.bdc2ecd3.sfr@canb.auug.org.au>
References: <20110406152915.bdc2ecd3.sfr@canb.auug.org.au>
Date: Wed, 6 Apr 2011 14:19:48 +0200
Message-ID: <BANLkTikG0=JbtbAQTOj9ij7EGPKb58sUbA@mail.gmail.com>
Subject: Re: linux-next: Tree for April 6
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 7:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> [The kernel.org mirroring is being slow.]
>
> Changes since 20110405:
>
> Dropped tree: xen
>
> The staging tree gained a conflict against the staging.current tree.
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).

Where is it?
No updates, only the US kernel-mirror in [3] has a patch.

In general:

Whom to contact in case of this GeoIP-related(?!) slowness to
kernel-mirrors for people from Europe?
This problem still exists here, since end of 2010 (so called
"android-stuff-sync").
"Here" means Wild Wild South-West Germany: *.kernel.org -> *.eu.k.o
I am now only taking the US-URLs to clone/pull/get my stuff.
Can you explain what's going on?

- Sedat -

[1] http://www.kernel.org/pub/linux/kernel/v2.6/next/?C=M;O=D
[2] http://git.eu.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary
[3] http://www.us.kernel.org/pub/linux/kernel/v2.6/next/patch-v2.6.39-rc1-next-20110406.gz

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1KIR2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:28:35 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54584 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1KIR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <4EBAB5F7.80000@xenotime.net>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
	<4EBAB5F7.80000@xenotime.net>
Date: Wed, 9 Nov 2011 12:28:33 -0500
Message-ID: <CA+5PVA6tBx4i1XZ+AF=uaOsjYCshG9CzXHWjnJcsJ=z1qw1F4A@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
From: Josh Boyer <jwboyer@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 12:18 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 11/07/2011 06:10 PM, Linus Torvalds wrote:
>
>> Which brings me to a question I already asked on G+ - do people really
>> need the old-fashioned patches? The -rc1 patch is about 22MB gzip-9'd,
>> and part of the reason is that all those renames cause big
>> delete/create diffs. We *could* use git rename patches, but then you'd
>> have to apply them with "git apply" rather than the legacy "patch"
>> executables. But as it is, the patch is almost a third of the size of
>> the tar-ball, which makes me wonder if there's even any point to such
>> a big patch?
>
> [email was too long/noisy, sorry for the delayed reply.]
> [should I admit that I don't follow you on g+ ?]
>
>
> Do you mean files like patch-3.2-rc1.gz or .bz2 or .xz?
> Yes, I use them, but if I am the only user of them, I'll get over it.

Fedora uses those.  We also used the -gitX snapshot patches when they
were generated, but now we do that by hand (which we also did for the
-rcX patches while kernel.org was down.)

josh

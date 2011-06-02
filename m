Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab1FBB0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 21:26:11 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42258 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1FBB0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 21:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g5OEhsR5CBTxamrE4DaLS4e6FUAu+2wFzDIQu6ZZxIm8VaTSjeXq6r6lqRHy6oIilG
         2aVCvAD85aMtCUfuEUDTvAscPROK3pk4wzsC+zKfxlRvwQKhi0nIcQz/FSlrkh4GuaNF
         GWE0/+sciZcSIKIsslAIIa6BLEoXdSmlYu6CA=
MIME-Version: 1.0
In-Reply-To: <20110601110616.861247de.sfr@canb.auug.org.au>
References: <20110601110616.861247de.sfr@canb.auug.org.au>
Date: Thu, 2 Jun 2011 02:26:07 +0100
Message-ID: <BANLkTim6MbS1E=9LyX=rsDr+JNuojPC4GQ@mail.gmail.com>
Subject: Re: linux-next: clean up time (pass 1)
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 2:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Looking through the trees currently included in linux-next, I get the
> feeling that some of them may be obsolete.
>
> Here is a list of tree that had no commits in them at the openning of the
> previous two merge windows:
>
> linux-spec
> pxa
> galak
> ceph
> configfs
> jfs
> squashfs

This is a surprise ... I'm sure I had commits in my squashfs
linux-next tree at the opening of the last but one merge window...

Linux 2.6.38 released 14 Mar 2011

$ git log --pretty="%ci %s"
...
2011-02-28 18:43:48 +0000 Squashfs: wrap squashfs_mount() definition
2011-02-28 18:35:44 +0000 Squashfs: xz_wrapper doesn't need to include squashfs_
2011-02-28 18:35:36 +0000 Squashfs: Update documentation to include compression
2011-02-28 18:35:28 +0000 Squashfs: Update Kconfig help text to include xz compr
2011-02-28 18:34:24 +0000 Squashfs: add compression options support to xz decomp
2011-02-28 18:21:59 +0000 Squashfs: extend decompressor framework to handle comp
2011-02-07 16:03:55 -0800 Linux 2.6.38-rc4

Phillip

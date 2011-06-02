Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab1FBCZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 22:25:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65360 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab1FBCZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 22:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dSoKvJu5D1cTJDGFlYzJS6dnVOS5xLdBkWEtdANttnHSTAhejJ3zJttKxYeBAuuWR1
         dMccX7SPK17oVTpTE2dUSeuSBRpgSLIXht/9nNSAESv86l1D767xLWBUZu/Z5eiZCqEZ
         daVgzT/ULh6lGWO10XC1K6Xis6IkCZRr9Iya8=
MIME-Version: 1.0
In-Reply-To: <20110602113826.a41bbd3d.sfr@canb.auug.org.au>
References: <20110601110616.861247de.sfr@canb.auug.org.au>
	<BANLkTim6MbS1E=9LyX=rsDr+JNuojPC4GQ@mail.gmail.com>
	<20110602113826.a41bbd3d.sfr@canb.auug.org.au>
Date: Thu, 2 Jun 2011 03:25:36 +0100
Message-ID: <BANLkTim-MPrnZ9+EaNtCQLsG9aukNhsiUw@mail.gmail.com>
Subject: Re: linux-next: clean up time (pass 1)
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 2:38 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Phillip,
>
> On Thu, 2 Jun 2011 02:26:07 +0100 Phillip Lougher <phillip.lougher@gmail.com> wrote:
>>
>> > squashfs
>>
>> This is a surprise ... I'm sure I had commits in my squashfs
>> linux-next tree at the opening of the last but one merge window...
>>
>> Linux 2.6.38 released 14 Mar 2011
>>
>> $ git log --pretty="%ci %s"
>> ...
>> 2011-02-28 18:43:48 +0000 Squashfs: wrap squashfs_mount() definition
>> 2011-02-28 18:35:44 +0000 Squashfs: xz_wrapper doesn't need to include squashfs_
>> 2011-02-28 18:35:36 +0000 Squashfs: Update documentation to include compression
>> 2011-02-28 18:35:28 +0000 Squashfs: Update Kconfig help text to include xz compr
>> 2011-02-28 18:34:24 +0000 Squashfs: add compression options support to xz decomp
>> 2011-02-28 18:21:59 +0000 Squashfs: extend decompressor framework to handle comp
>> 2011-02-07 16:03:55 -0800 Linux 2.6.38-rc4
>
> plus or minus 1 day (and timezone jitter :-)):
>
> $ git rev-list --no-merges next/20110314/origin..next/20110314/squashfs | wc -l
> 0
> $ git rev-list --no-merges next/20110315/origin..next/20110315/squashfs | wc -l
> 0
> $ git rev-list --no-merges next/20110316/origin..next/20110316/squashfs | wc -l
> 6
>

Bugger, maybe I forgot to push, though I thought I did  :-)

Phillip

> It doesn't really matter, it was just a quick metric to choose a subset
> of trees to look at.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

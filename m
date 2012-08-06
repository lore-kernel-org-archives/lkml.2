Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2HFB50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:57:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45906 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab2HFB5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120806104841.07ed3708b600529ff7eb6fa6@canb.auug.org.au>
References: <20120806104841.07ed3708b600529ff7eb6fa6@canb.auug.org.au>
Date: Sun, 5 Aug 2012 20:57:24 -0500
Message-ID: <CAH2r5ms9EYUV7uwCpU6De9y_PFtFG6wfekPVRXQza6pE6TVC4Q@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 5, 2012 at 7:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/Kconfig:3: syntax error
> fs/Kconfig:244: missing end statement for this entry
<snip>
>
> Caused by commit 12f3f9b7c80c ("Remove sparse warning in cifsfs.c").
> Please, please build test after doing updates and before publishing your
> tree.
>
> I have used the cifs tree from next-20120803 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

Fixed.  The corrupted commit came after a build test caught a few
sparse warnings - forgot to rerun the build test though after fixing
the warning (I had multiple
Kconfigs I build test - fs/cifs/Kconfig obviously should not have changed)



-- 
Thanks,

Steve

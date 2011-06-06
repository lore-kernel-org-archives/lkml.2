Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1FFKgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:36:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48504 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1FFKga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NcbOHMWAPPuVL3dZ3NSP3X8CJ2eL0Mn3ZDoinEdIiWDDKGKg4fK/nUJ5zFA2M2Cdit
         kDO2hC2ZbyyeVCi2E8zf6nekis0ueQsioUvL3GQfRAujzSmBZT+5IT+Rs3mtAuFuxZr0
         DaUCkFdDb5c9XcACDMZbuecptMGwzu5oYBrW8=
MIME-Version: 1.0
In-Reply-To: <BANLkTik-xtEnf8Bxz3PmP6H+YYSDXe1adw@mail.gmail.com>
References: <BANLkTinrbh7Xi27an3uY7pDWrNKhJRYmEA@mail.gmail.com>
	<BANLkTik-xtEnf8Bxz3PmP6H+YYSDXe1adw@mail.gmail.com>
Date: Mon, 6 Jun 2011 12:36:30 +0200
Message-ID: <BANLkTimDu8YAb1uOMDqVLSX86=hZeyoAgA@mail.gmail.com>
Subject: Re: Linux 3.0-rc2
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:27 PM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> On Mon, Jun 6, 2011 at 11:32 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> You all know the drill by now: another week, another -rc.
>>
>> It's been reasonably quiet, although the btrfs update is bigger than I
>> was hoping for. Other than that, it's mostly driver fixes, some ubifs
>> updates too, and a few reverts for the early regressions.
>>
>> But -rc2 is already small enough that it easily fits as an appended
>> shortlog, and hopefully things will stay calm. Of course, part of that
>> may be due to other people also havin been busy traveling, so let's
>> see (and hope for the best). And I haven't been super-eager to pull,
>> so there is a couple of pending requests still in my mail queue.
>
> 3.0-rc2 tarball appeared, but patch-3.0-rc2.bz2/gz hasn't yet,
>  at least according to the proxy server I'm currently behind.

Actually I'm not so sure what I said is true: 3.0-rc2.tar.gz appeared, but
 it's too small, at 15MB vs the 92MB of -rc1...

And I can't tell what's inside, as the helpful antivirus product within the
 proxy quits due to too many files in the tarball I'm attempting to download.

Sigh.

Waiting for the diff to pop up. Thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")

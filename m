Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1AVLaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:30:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56483 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1AVLaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:30:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=OEhWu7cQtl5DycKAbSeMrK7g/93SmieQg0vRZNYljIIPtZGcmYm8c+KABt0EDZdm9l
         RlL5qC6Pz2p2/WUaqTTyNSDJ6bJMZHEC2rY09wEIXmFl/4uIrXPS0A2pqo/1GHvGjAh+
         n04RasLdnJ90VdhNZaSc0SpwOLQPeb0VN0j28=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D3ABA37.2040900@example.com>
References: <AANLkTi=bxD0wpJ9o1G5V2rOd4TtHsGS0LuePNXPaWJg9@mail.gmail.com>
	<4D3ABA37.2040900@example.com>
Date: Sat, 22 Jan 2011 12:30:08 +0100
Message-ID: <AANLkTikaB_A7Oc+AvheGc3bEgTQUQ_KqiVp7Jwup=5-4@mail.gmail.com>
Subject: Re: 2.6.38-rc2 tarballs? XZ-compressed source tarballs?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: piotr@hosowicz.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/22 Piotr Hosowicz <piotr@hosowicz.com>:
> On 22.01.2011 12:00, Sedat Dilek wrote:
>>
>> Hi,
>>
>> I was wondering why there are no 2.6.38-rc2 tarballs available in testing/
>> [1].
>
> Me too.
>
> Regards,
>
> Piotr Hosowicz
>
> --
> Polsat: oglądasz z rodzinką reklamy, a tu nagle - trach! - film!
> NP: Peter Green Splinter Group - Madison Blues
> NB: 2.6.38-rc1-20110121-1701-tidm+
>

I had to be more precise... there is only TAR.GZ tarball [1].

$ cd ~/src/linux-2.6

$ tar -xf files/linux-2.6.38-rc2.tar.gz

$ tar --use-compress-program=xz -cf files/linux-2.6.38-rc2.tar.xz
linux-2.6.38-rc2/

$ ls -l linux-2.6.38-rc2.tar.*
-rw-r--r-- 1 sd sd 94091552 22. Jan 04:57 linux-2.6.38-rc2.tar.gz
-rw-r--r-- 1 sd sd 64857696 22. Jan 12:25 linux-2.6.38-rc2.tar.xz

$ du -h linux-2.6.38-rc2.tar.*
90M     linux-2.6.38-rc2.tar.gz
62M     linux-2.6.38-rc2.tar.xz

$ du -k linux-2.6.38-rc2.tar.*
91892   linux-2.6.38-rc2.tar.gz
63344   linux-2.6.38-rc2.tar.xz

$ file linux-2.6.38-rc2.tar.*
linux-2.6.38-rc2.tar.gz: gzip compressed data, from Unix, last
modified: Sat Jan 22 04:33:14 2011, max compression
linux-2.6.38-rc2.tar.xz: XZ compressed data

Default compression-level of XZ is 6 (9 is best), so a 28M smaller
tarball as a number speaks for itself.

- Sedat -

[1] http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.38-rc2.tar.gz

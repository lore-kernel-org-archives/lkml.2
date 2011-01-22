Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1AVLkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:40:00 -0500
Received: from 30.mail-out.ovh.net ([213.186.62.213]:57466 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752314Ab1AVLj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:39:59 -0500
Message-ID: <4D3AC20B.5020706@example.com>
Date: Sat, 22 Jan 2011 12:39:55 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.38-rc2 tarballs? XZ-compressed source tarballs?
References: <AANLkTi=bxD0wpJ9o1G5V2rOd4TtHsGS0LuePNXPaWJg9@mail.gmail.com>	<4D3ABA37.2040900@example.com> <AANLkTikaB_A7Oc+AvheGc3bEgTQUQ_KqiVp7Jwup=5-4@mail.gmail.com>
In-Reply-To: <AANLkTikaB_A7Oc+AvheGc3bEgTQUQ_KqiVp7Jwup=5-4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13982550943552074144
X-Ovh-Remote: 178.42.75.162 (afmx162.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.01.2011 12:30, Sedat Dilek wrote:
> 2011/1/22 Piotr Hosowicz<piotr@hosowicz.com>:
>> On 22.01.2011 12:00, Sedat Dilek wrote:
>>>
>>> Hi,
>>>
>>> I was wondering why there are no 2.6.38-rc2 tarballs available in testing/
>>> [1].
>>
>> Me too.
>
> I had to be more precise... there is only TAR.GZ tarball [1].

Yes, I expected tar.bz2 linked to the main page.

> $ cd ~/src/linux-2.6
>
> $ tar -xf files/linux-2.6.38-rc2.tar.gz
>
> $ tar --use-compress-program=xz -cf files/linux-2.6.38-rc2.tar.xz
> linux-2.6.38-rc2/
>
> $ ls -l linux-2.6.38-rc2.tar.*
> -rw-r--r-- 1 sd sd 94091552 22. Jan 04:57 linux-2.6.38-rc2.tar.gz
> -rw-r--r-- 1 sd sd 64857696 22. Jan 12:25 linux-2.6.38-rc2.tar.xz
>
> $ du -h linux-2.6.38-rc2.tar.*
> 90M     linux-2.6.38-rc2.tar.gz
> 62M     linux-2.6.38-rc2.tar.xz
>
> $ du -k linux-2.6.38-rc2.tar.*
> 91892   linux-2.6.38-rc2.tar.gz
> 63344   linux-2.6.38-rc2.tar.xz
>
> $ file linux-2.6.38-rc2.tar.*
> linux-2.6.38-rc2.tar.gz: gzip compressed data, from Unix, last
> modified: Sat Jan 22 04:33:14 2011, max compression
> linux-2.6.38-rc2.tar.xz: XZ compressed data
>
> Default compression-level of XZ is 6 (9 is best), so a 28M smaller
> tarball as a number speaks for itself.

Wow!

Regards,

Piotr Hosowicz

-- 
W trosce o najm³odsze pokolenie, nasi ustawodawcy winni znowelizowaæ
ustawê o wychowaniu w trze¼wo¶ci i przeciwdzia³aniu alkoholizmowi tak,
¿eby zakazaæ wprowadzania na rynek gier planszowych, których celem
jest jak najszybsze dotarcie do mety.
NP: ZZTop - Crucifixx a flatt
NB: 2.6.38-rc1-20110121-1701-tidm+

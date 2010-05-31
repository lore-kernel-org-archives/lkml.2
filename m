Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0EaUwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:52:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58351 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0EaUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:52:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/5] perf stat: add perf stat -B to pretty print large numbers
In-Reply-To: Your message of "Mon, 31 May 2010 21:30:36 +0200."
             <AANLkTimBxG-2TVC7hAfvRHWupa8T7FaVEcDTnAMCtQWy@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1274234900-12162-1-git-send-email-acme@infradead.org> <1274234900-12162-2-git-send-email-acme@infradead.org> <52092.1275333099@localhost>
            <AANLkTimBxG-2TVC7hAfvRHWupa8T7FaVEcDTnAMCtQWy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275338942_6730P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 31 May 2010 16:49:02 -0400
Message-ID: <77282.1275338942@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C0420BF.0083,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275338942_6730P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 31 May 2010 21:30:36 +0200, Stephane Eranian said:
> >> instance LC_NUMERIC=3Den_US.UTF8. You need to pass -B to activate th=
is
>>> feature. This way existing scripts parsing the output do not need to =
be
>>> changed. Here is an example.

Two examples, actually...

>>>
>>> =24 perf stat noploop 2
>>> noploop for 2 seconds
>>>
>>> =A0Performance counter stats for 'noploop 2':
>>>
>>> =A0 =A0 =A0 =A0 1998.347031 =A0task-clock-msecs =A0 =A0 =A0 =A0 =23 =
=A0 =A0 =A00.998 CPUs
>>>   =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A061 =A0context-switches =A0 =A0 =A0 =
=A0 =23 =A0 =A0 =A00.000 M/sec
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0CPU-migrations =A0 =A0 =A0 =
=A0 =A0 =23 =A0 =A0 =A00.000 M/sec
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 118 =A0page-faults =A0 =A0 =A0 =A0 =
=A0 =A0 =A0=23 =A0 =A0 =A00.000 M/sec
>>> =A0 =A0 =A0 4,138,410,900 =A0cycles =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =23 =A0 2070.917 M/sec =A0(scaled from 70.01%)
>>> =A0 =A0 =A0 2,062,650,268 =A0instructions =A0 =A0 =A0 =A0 =A0 =A0 =23=
 =A0 =A0 =A00.498 IPC =A0 =A0(scaled from 70.01%)
>>> =A0 =A0 =A0 2,057,653,466 =A0branches =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =23 =A0 1029.678 M/sec =A0(scaled from 70.01%)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A040,267 =A0branch-misses =A0 =A0 =A0 =A0 =
=A0 =A0=23 =A0 =A0 =A00.002 % =A0 =A0 =A0(scaled from 30.04%)
>>> =A0 =A0 =A0 2,055,961,348 =A0cache-references =A0 =A0 =A0 =A0 =23 =A0=
 1028.831 M/sec =A0(scaled from 30.03%)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A053,725 =A0cache-misses =A0 =A0 =A0 =A0 =A0=
 =A0 =23 =A0 =A0 =A00.027 M/sec =A0(scaled from 30.02%)
>>>
>>> =A0 =A0 =A0 =A0 2.001393933 =A0seconds time elapsed
>>>
>>> =24 perf stat -B =A0noploop 2
>>> noploop for 2 seconds
>>>
>>> =A0Performance counter stats for 'noploop 2':
>>>
>>> =A0 =A0 =A0 =A0 1998.297883 =A0task-clock-msecs =A0 =A0 =A0 =A0 =23 =
=A0 =A0 =A00.998 CPUs
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A059 =A0context-switches =A0 =A0 =A0=
 =A0 =23 =A0 =A0 =A00.000 M/sec
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0CPU-migrations =A0 =A0 =A0 =
=A0 =A0 =23 =A0 =A0 =A00.000 M/sec
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 119 =A0page-faults =A0 =A0 =A0 =A0 =
=A0 =A0 =A0=23 =A0 =A0 =A00.000 M/sec
>>> =A0 =A0 =A0 4,131,380,160 =A0cycles =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =23 =A0 2067.450 M/sec =A0(scaled from 70.01%)
>>> =A0 =A0 =A0 2,059,096,507 =A0instructions =A0 =A0 =A0 =A0 =A0 =A0 =23=
 =A0 =A0 =A00.498 IPC =A0 =A0(scaled from 70.01%)
>>> =A0 =A0 =A0 2,054,681,303 =A0branches =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =23 =A0 1028.216 M/sec =A0(scaled from 70.01%)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A025,650 =A0branch-misses =A0 =A0 =A0 =A0 =
=A0 =A0=23 =A0 =A0 =A00.001 % =A0 =A0 =A0(scaled from 30.05%)
>>> =A0 =A0 =A0 2,056,283,014 =A0cache-references =A0 =A0 =A0 =A0 =23 =A0=
 1029.017 M/sec =A0(scaled from 30.03%)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A047,097 =A0cache-misses =A0 =A0 =A0 =A0 =A0=
 =A0 =23 =A0 =A0 =A00.024 M/sec =A0(scaled from 30.02%)
>>>
>>> =A0 =A0 =A0 =A0 2.001391016 =A0seconds time elapsed
>>
>> Is it me, or did -B not make any difference for these two examples?
>> I'm confused.

> Did you set the LC_NUMERIC environement variable?

I meant I was reading the two examples given, and I'm seeing commas in
the same places, -B or not -B.  I was sort of expecting that the first
example wouldn't have commas in it, or something?  Or were those two
examples *supposed* to be identical, and there's a not-shown 3rd example
that shows what you get if you use -B and set the LC_NUMERIC variable?

--==_Exmh_1275338942_6730P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMBCC+cC3lWbTT17ARAnStAKD+6E8o2IghlRupfu5qazpFrF47fACg2nE+
Wv8yxHD5rsrLkfwXmjd5t6Y=
=1Zy0
-----END PGP SIGNATURE-----

--==_Exmh_1275338942_6730P--


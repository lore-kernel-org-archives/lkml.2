Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab0HFU7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:59:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61922 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935401Ab0HFU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp
         :x-pgp:date:in-reply-to:message-id:user-agent:mime-version
         :content-type;
        b=cWtWV2KmXOnMEY+Ghsrqyp3YMtvvhBcoG7qncwogL5P11SSAQCghRCKluvxJMfCit8
         YYJZiX2e+AdrvrHThq2uFTRqd81Ew+KzB7rJYMKQX/jAzq8+ob/qmMlRifyAWVidf3+V
         f9E2H3Xooyex19vrsE7Ij4hDgH3NpWrgNo8gM=
From: Michal Nazarewicz <mina86@mina86.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] lib: vsprintf: added a put_dec() test and benchmark tool
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
	<201008060710.06304.vda.linux@googlemail.com>
	<op.vg0csju97p4s8u@pikus>
	<201008062126.10789.vda.linux@googlemail.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Fri, 06 Aug 2010 22:58:37 +0200
In-Reply-To: <201008062126.10789.vda.linux@googlemail.com> (Denys Vlasenko's
	message of "Fri, 6 Aug 2010 21:26:10 +0200")
Message-ID: <87y6cj791e.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Denys Vlasenko <vda.linux@googlemail.com> writes:

> On Friday 06 August 2010 10:34, Micha=C5=82 Nazarewicz wrote:
>> On Fri, 06 Aug 2010 07:10:06 +0200, Denys Vlasenko <vda.linux@googlemail=
.com> wrote:
>>=20
>> > On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
>> >> This commit adds a test application for the put_dec() and
>> >> family of functions that are used by the previous two commits.
>> >>
>> >> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>> >
>> >> +put-dec-test: put-dec-test.c
>> >> +	exec $(CC) $(CFLAGS) -o $@ $<
>> >
>> > (1) Why exec?
>>=20
>> Micro Makefile optimisation -- saves us a fork().
>>=20
>> I'll try to fix the benchmark over the weekend and will post updated
>> version.  Thanks for the comments.
>
> You might find some ideas in the attached file:
> * removed "correction" code
> * added verification of correctness for put_dec()
> * different rand64
>   (old one was giving same "random" number surprisingly often)
> * more robust coding in a few places

Thanks!  I actually changed the benchmark earlier today and redid all
benchmarks but I'll sure incorporate you're test code.

Also, I've removed rand_64() from my code in favour of reading random
data from /dev/urandom.  In consequence, all functions ale benchmarked
using the same values and it's still random (ie. no the same value all
the time).  This also made "correction" no longer needed.

It's 11pm here, so I'll try to send the new patches tomorrow morning
after getting some sleep.

Once again, thank you for all the comments and suggestiveness!

=2D-=20
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=3D./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkxcd40ACgkQUyzLALfG3x7vWQCfb2lN6R7N0uXmYTHHinpDLGmZ
JhAAniUEzDmNHLdSptCcz85wlQ3ED45c
=VKGI
-----END PGP SIGNATURE-----
--=-=-=--

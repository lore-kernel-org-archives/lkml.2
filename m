Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0FCJCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:02:45 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:37979 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab0FCJCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:in-reply-to:references:user-agent:x-face
         :face:x-url:x-pgp-fp:x-pgp:date:message-id:mime-version:content-type;
        b=I8XPpOhEs39esuKWsMXHf2QCWlwgzKkXSSFA+/VYf4N21jJ2thphXrRZlHXYF+PrrO
         +1IoItzOVvcdjpTaPl6Q936+nhoN1aDJGohMvzJDbN2lLa60m/kkYGgQd+3mz4pQ1H6n
         pJSiJfBAM+INOCqc50kfELitHlNpqgz3vXqik=
From: Michal Nazarewicz <mina86@mina86.com>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 07/11] USB: gadget: g_multi: added documentation and INF  files
In-Reply-To: <AANLkTikKgpm5j453ApJoMeskZdac8iXTBODzb-lCpMT1@mail.gmail.com>
	(Xiaofan Chen's message of "Thu, 3 Jun 2010 13:16:24 +0800")
References: <cover.1275481997.git.mina86@mina86.com>
	<5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
	<e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
	<785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
	<5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
	<17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
	<381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
	<c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
	<AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
	<op.vdojfktu7p4s8u@pikus>
	<AANLkTinwDV9Egrfy_ml998vWIKWs5AasrJMrgxIWOrCo@mail.gmail.com>
	<AANLkTikKgpm5j453ApJoMeskZdac8iXTBODzb-lCpMT1@mail.gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Thu, 03 Jun 2010 11:02:21 +0200
Message-ID: <87ljaw1obm.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>>> On Wed, 02 Jun 2010 15:02:54 +0200, Xiaofan Chen <xiaofanc@gmail.com> w=
rote:
>>>> LayoutFile=3Dlayout.inf
>>>> CatalogFile=3D%MFGFILENAME%.cat

>> 2010/6/2 Micha=C5=82 Nazarewicz <m.nazarewicz@samsung.com>:
>>> So, what is this cat file for?=20

> 2010/6/3 Xiaofan Chen <xiaofanc@gmail.com>:
>> In a word, that line can be deleted.

In that case, I'll try to test the new INF files on various Windows
versions and will probably send updated patchset to the list.

Xiaofan Chen <xiaofanc@gmail.com> writes:
> Just hope the Linux USB developers will not be bored by this kind
> of Windows specific information.

Someone has to do that.  If there's someone who knows that stuff it'll
be a sin not to use his expertise. :)

> Here is the nice writeup by Microsoft about KMCS.
> http://www.microsoft.com/whdc/driver/install/drvsign/kmcs-walkthrough.mspx

Wow...  Honestly, 56 pages? They sure know how to make "openssl dgst
=2Dsign" complicated...

I'll have to put that on my TODO list thought it may take some time till
I get to singing drivers.

> So if your employer (Samsung) or others is quite nice and submit the
> driver package (the inf and cat file for CDC-ACM) for WHQL and got
> approved, in the future, uses of the inf file will not see the red color
> warning. This might be desired for corporate customers.

I *personally* see how it may be a problem for _any_ corporation since
singing is like saying "yes, we guarantee it won't destroy your computer
nor it will summon demons" and by releasing signed driver you in effect
loose control over it.  Again, further signature investigations are on
my TODO list.

=2D-=20
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=3D./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkwHb6sACgkQUyzLALfG3x5QpwCeL7EH/TRkwdgTPk8ycxd08pv/
NAMAn1hlhrgXsQPz52douqGiq4xJbMhW
=prnb
-----END PGP SIGNATURE-----
--=-=-=--

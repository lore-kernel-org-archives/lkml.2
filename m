Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1KFVfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:35:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58249 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1KFVfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:35:31 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linaro-mm-sig\@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
        "'Subash Patel'" <subashrp@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>
Subject: Re: CMA v16 and DMA-mapping v13 patch series
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF3622549EBE58@bssrvexch01>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Sun, 06 Nov 2011 22:35:16 +0100
In-Reply-To: <ADF13DA15EB3FE4FBA487CCC7BEFDF3622549EBE58@bssrvexch01> (Marek
	Szyprowski's message of "Thu, 20 Oct 2011 08:01:12 +0200")
Message-ID: <87lirtgciz.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Marek Szyprowski <m.szyprowski@samsung.com> writes:
> Linux v3.1-rc10 with both CMA v16 and DMA-mapping v3:
> git://git.infradead.org/users/kmpark/linux-2.6-samsung 3.1-rc10-cma-v16-d=
ma-v3

I've pushed a new version based on Mel's suggestions to=20

     git://github.com/mina86/linux-2.6.git cma-17

Unfortunately, it took me more time then I anticipated and so I had no
time to test the code in any way (other then compile it on x86_64).

=2D-=20
Best regards,                                          _     _
 .o. | Liege of Serenly Enlightened Majesty of       o' \,=3D./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
 ooo +-<mina86-mina86.com>-<jid:mina86-jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk62/Z4ACgkQUyzLALfG3x79TwCghV+S7VGchGmHFCcE70bs9kwB
93kAn1QslNio6hpatD2GoUQLjzYxSyJJ
=UBof
-----END PGP SIGNATURE-----
--=-=-=--

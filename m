Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2ILKc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:32:59 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52766 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2ILKc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:32:57 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] mm: refactor out __alloc_contig_migrate_alloc
In-Reply-To: <1347414231-31451-1-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1347414231-31451-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 12 Sep 2012 12:32:48 +0200
Message-ID: <xa1tmx0vh6pb.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 12 2012, Minchan Kim <minchan@kernel.org> wrote:
> __alloc_contig_migrate_alloc can be used by memory-hotplug so
> refactor out(move + rename as a common name) it into
> page_isolation.c.
>
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQUGTQAAoJECBgQBJQdR/0+XEP/icziRPERoSNxQUvAculm9F5
5jEvNJaKkvk//kp+wJQvR2+5SWvc9rrsRD//cgONGgBqbu2uFlkinsE0kn4sxjIh
w6hLPRi6BvOfmepfCz6tw4lVHlCU3ilgK39Cm/cN6vObYk8kY/b2LMGpRLWJQ16o
+ZSJhiirLZetGCqzt0JVbibSxWnhf4/P99f6WJ2xw0ukeYdv8Y4nWkzG3b3Z/mjo
F/cFegMqGxzVfa3YZPERMufF7e9L6jysW+9T37BXtDd6Hz0JRfWjMN5sUHXyyT79
auRLHylTBs3X/ekxS5Z0sjtCh0tdYjhFbrkNiU3M5fQysomoorYULWG5zMNt4dS7
jjR+RYk7kN1HBcUQwdk7+NWkly9O8/2VCUeP+zggLxSsJTAATf0ngiFPks5g/D2k
A7DLaWxdoPnpALxlVdv47Q0qGCV76GsitB8m9vVI9Ou/AZCO9qzpQLjN5KbTYqx+
NtvypcpOtr54cqColTg+U4ShCPMYP0xoocMQIaKy/se8iRMguBw6ScOAlpFx0cOy
n25u+0jf95IopF4mEQcceMdqzEtjSH92rWT8HgKYqP8G/zlJW5IGjbsSKog/Kqsw
VeIhJ/CjPFXm9vzyXv3+tD0EYdClPS+93AW01yURPa7NAk12xaGj8PvlFDs/PN9V
0wFbTPY2V7NBY+1eihNY
=xAm+
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

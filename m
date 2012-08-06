Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2HFL6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:58:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38682 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2HFL6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:58:43 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Rob Clark <rob.clark@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        patches@linaro.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, m.szyprowski@samsung.com, daniel@ffwll.ch,
        sumit.semwal@ti.com, maarten.lankhorst@canonical.com,
        Rob Clark <rob@ti.com>
Subject: Re: [PATCH 2/2] dma-buf: add helpers for attacher dma-parms
In-Reply-To: <501F9C8E.4080002@samsung.com>
Organization: http://mina86.com/
References: <1342715014-5316-1-git-send-email-rob.clark@linaro.org> <1342715014-5316-3-git-send-email-rob.clark@linaro.org> <501F9C8E.4080002@samsung.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/24.1.50.2 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 06 Aug 2012 13:58:32 +0200
Message-ID: <xa1tobmoxmdz.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Tomasz Stanislawski <t.stanislaws@samsung.com> writes:
> I recommend to change the semantics for unlimited number of segments
> from 'value 0' to:
>
> #define DMA_SEGMENTS_COUNT_UNLIMITED ((unsigned long)INT_MAX)
>
> Using INT_MAX will allow using safe conversions between signed and
> unsigned integers.

LONG_MAX seems cleaner regardless.

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

iQIcBAEBAgAGBQJQH7FoAAoJECBgQBJQdR/0Bp8P/1JRasCO7JTR74Tp7r6IRZsh
EX2hh1vYKHtXIvD/inKsnOdnm6NFO+kzwnSS3ozkQZkIuhvTYkZyKcXJ7tHYHOZb
Y9x/4VaG8bPi4AzPs2a5WuCnyP6ex5MwZTfPYir2CmWFicTNwYCtveNwcxIiI8w5
D24UmHDwi2C23rCP57vepsyMDQk6NpukgqCe5u2FW+ep2Uu2ai6tW/GgP7V6xD2j
jdLKcA0H5YMjzYLuWX3HYGLRbpOWV7KBp4O4bYn+7RlrSUQNRv92Erse+zitFLxt
8l6ULsb64gsixV1YpKte6ofhWf9Y8Zk+fmXkA0WQnaaRTskTN5XIgAvohnjZX9cT
G68NVPa/XhXt9YmWvHave1BOMNFMcfcmBXNwtQDfB6v8UNQoUqeGFBhDye7vmJXx
yu41FUrFAh4JrYTt4dpSWqG4mU50YM17BF7JIq+F8bVuH4asIXlM+rcdid0t+slt
ujotZ6ElWxqaGB5KCsanofSuNd8KgNjGLpgYR7z89VlSrgTocafZjZgTAnR9GU3h
kqszsTuUg+Gr98Gf7rSiqhVRSSAwi6TazZVD+DuWnuhPtzKpBhj0tTidfDufClgM
V99Zmu6Oc+qRKdv0M3kaA8xYZWk+TpNSQsHSGqmzeDAwicLej5qP/5EEklKEz6RO
IS4s+j0jiXCjVTxtXhTm
=l0/5
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

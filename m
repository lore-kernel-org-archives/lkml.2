Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2IEMlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:41:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54208 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2IEMlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:41:31 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 1/2] mm: change enum migrate_mode with bitwise type
In-Reply-To: <1346832673-12512-1-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1346832673-12512-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/0.14+2~g416b120 (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 05 Sep 2012 14:41:21 +0200
Message-ID: <xa1tpq60prpq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05 2012, Minchan Kim wrote:
> This patch changes migrate_mode type to bitwise type because
> next patch will add MIGRATE_DISCARD and it could be ORed with other
> attributes so it would be better to change it with bitwise type.
>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Suggested-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

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

iQIcBAEBAgAGBQJQR0hxAAoJECBgQBJQdR/0gwwP/RJlbZFdIP6gyyiMI6lP2YFy
QRoG1uUjrQTw74grU6PAkO1C5Lji1X15pQJLcu5lJYPQCEa8AwJLCDa46C8xVZlY
4PFDdMdatFQtcenxK1OsEkmXsWZJWHT8/1KVr+RXhn3N0Z7RCAgcjwCNgb6OgrWo
0g3KuvMLp8jidEPPWKNlWyew7B41dXpwsKdLipf0MCkqJRke1zWBIPE2pkvRFDC5
REemuyN9/FJZEoX6ysVyeXt2X6jm9U5JLPDbnWfxgWBYtV+p8auI70kEy3SguKZo
BY7P54hJYAZx0VjCMEl2D3TdwN6XIGwuxvPLcIn/srm0EI3ka6RX8+iA8IE+wS8g
sAaIBCWdioFey+AKvE8mCyNA2ywXoBByn57OZvvsdQILTJCOX6BAgeasg41+aWor
rH+hWAB7SlN+XxbGPOLLT3TskYh7MuGFo8BgAir2vBnTz4yt1bVw0hFRd6mz4ZSC
AlwvulAWEPqrCnBqI5vlRnS9VIYMIEpycjjcZ1OnxWVg9HJFLqIEHGKRmxxkRaJY
KaNgTlMAtgCU6f2uSftzEzzSRKDNRmgvaJGFmhGg2oaUpAfIqfjYTDlA1q5jsGfw
EFjsJWeZG62QDLkvgiupoLpCSIr8bpXyWkokDKDjPbxSE/MWzVKQ4AS23D663bI+
lIaya+3sywBGB+aEPeOW
=8tXk
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--

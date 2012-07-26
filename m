Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2GZLyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:54:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37791 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758Ab2GZLyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:54:53 -0400
Date: Thu, 26 Jul 2012 12:54:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 06/21] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120726115450.GE3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VZLKKa0PG5KXlQhV"
Content-Disposition: inline
In-Reply-To: <1343298534-13611-7-git-send-email-lee.jones@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VZLKKa0PG5KXlQhV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 11:28:39AM +0100, Lee Jones wrote:

> If a list of widgets is provided and one of them fails to be added as
> a control, the present semantics fail all subsequent widgets. A better
> solution would be to only fail that widget, but pursue in attempting
> to add the rest of the list.

Why?

--VZLKKa0PG5KXlQhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQETABAAoJEBus8iNuMP3dqxIQAJMqeSzER9BBBf6Z6Qbv/B9/
2mkXg3YL4l1AVrQ3nRdqfu765QxTIL1P82Eu+yJH3kQUOvvAoqDjjGCrmT3AEflE
DVK8dplcIiT1CrqMbk+ZLOhyzuPna0AwwgTJI85RM+py+9ppzk2V+PILk2H1Z5H5
YD9mLIlQV4vsxqDJAXSC485xtc6c+u5EAA8s4+9ZoCvbyUT2AtiTKxAV+sydAY4x
7RB57XfceusEnuQAcbWHnRy5e8/wp2yDJe2GX/Co+4QOuUN/BIo9trBQCQgQW3CD
LHlC/yQ5KIzqncEGfl4ymrm1ecBcja4AjqGBkxo+aEMNH0JFvG/hoKQv2dxwe+Gq
gSoIxx8k8fO9v6BWe04NRBFUV3+AieMlkviHWlRoao02j5RI9Nqys2iGpZn64qKN
QiD1gjBzBrSNJEpRuceMVYeWKwwB6nNOkmxxYTiK8NgIK8o8IOtfKhZFIINBTJFi
J06iPwsRwPBhL7Kqnka6RtQskr2f1Fc0SDEfhWgHTc1LYOVFH+swiNFmZ7H8YFt4
ibeHQYSCz65cP5hayIMIak78x0hZC+RkrR+b1TcVLfb069jFVHwqHFKSuTQYz/x9
2SWCTvJsYqmYxV49ofLPfLtBuM7igy836MNoLXPgjYsUSSuwDJBooaVgtNZlgyAk
FWtYPJZNvZVAksmAk32Y
=5/Sj
-----END PGP SIGNATURE-----

--VZLKKa0PG5KXlQhV--

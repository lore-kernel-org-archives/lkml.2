Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230Ab2DLSgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:36:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55661 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab2DLSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:36:14 -0400
Date: Thu, 12 Apr 2012 19:36:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Message-ID: <20120412183610.GD18049@opensource.wolfsonmicro.com>
References: <1334132429-6091-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1334146730.23924.238.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <1334146730.23924.238.camel@gandalf.stny.rr.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 08:18:50AM -0400, Steven Rostedt wrote:

> Please change your subject when you submit a new patch. I've ignored
> your last one because I thought I already applied it.

I wrote the subject for the second patch completely from scratch when I
noticed the build error I'm afraid - more variation in the build errors
would mean more variation in the subjects!

> As with this one, has the same subject. I only noticed it as I was about
> to tell you that it was already applied.

Which wouldn't have been the end of the world, it'd at least have been a
response.

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhyCLAAoJEBus8iNuMP3d0LYP/3//MjcQiHHH4g/wpyfVyYA5
3lOKnzmfliyV7nqTOmp3oq0fvcKeVvwS4zuhD9kmHkrosu5ZWNehYXrglhhNnEsl
rOAsgqNam0QuqPGiEgMyAQmPijpCBfz63uZLfF5s1yTj1iH5EgoHxzuPtOXzQqTC
tMfRfedYxMZfO4XMumJtay1y/OevuCS4KSmQ62iJ0C6Y1FknkRjEIxCNBqkUYJF5
lnG+ZX6ooFPb8ZlqDt1YuWwCEJW7uovmtXV2qP1R9+kEIU03yh245TW7DMNtYzIn
fCPm9539PEamoxShjuTk9MbNHEFOaoH6mF58Kr3WIKnfJK/R4NO4YRz3gPC9BRea
gkBVp03hSTE0Ckkc4GOTxkDNPDY6luCF7fH6ByaII/tFItin/AlZciZU9TqJvzTJ
9fqXUnuMB7OyfKoneG0PaTQLubgZ9rDXA0MJ0r1VDJTdBkLpiMQe1aUvNLKnuolB
4+PVURs8KsYT2V/UiVh0kVDat0Qus3okeAU2H8v7qwWjfmr0l1Jkub3N80FWcjPD
//0cDibvb/+OpQP3IT3hxHB3Bkj/B82FJqejeEp4wUdM06reX7sMl0orjvyqwvjW
tEe+6TU9ypIBRciocpVN0zoq3viC+3TxBxJ5Ch2ZDDuWhb8fIj5Q2xKD0Qor+TU6
2qaOqFh1CkhsmI/Ym91n
=V47v
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--

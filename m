Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2FQT4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:56:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38553 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab2FQT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:56:21 -0400
Date: Sun, 17 Jun 2012 20:56:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps65023: Set n_voltages to 1 for fixed
 voltage
Message-ID: <20120617195619.GJ4267@opensource.wolfsonmicro.com>
References: <1339640579.16332.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2VXyA7JGja7B50zs"
Content-Disposition: inline
In-Reply-To: <1339640579.16332.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2VXyA7JGja7B50zs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 14, 2012 at 10:22:59AM +0800, Axel Lin wrote:
> For fixed voltage, the n_voltages should be 1 rather than 0.

Applied, thanks.

--2VXyA7JGja7B50zs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jZcAAoJEBus8iNuMP3dk8EP/2nw6+wACgP7b2rKvuw/l9YY
0zuKVktB+vnNfqe8XbPw4lA205o7g69gb/ReUdWl46md0mLO67ndjx6sZLMrQI6+
OrxegNYxZn99Ed8XYrb5rclqVJxl+3mb7c22WCPAP2F9uPF4KH9GjdOi54JQeLAE
LZvqSAg3FcIg5OBfdRQasYR0+bzC87zL5jOuvXq9vg3w4IMZ0NQ0I0/AyF9s8PJk
pM2Ye1T/XFrMQgZCp0qBcdHHI0MtOrtprZ6Uoql54xxoU6Z1vu5QL+zhvZEgcpM5
Tv05Ts0ydaYwvn7vBdsGGvxP3JWfdq/raYxGwVmN9JA4HCxV7n5+69KES/K2v1S9
2KN+vfPIy1XBdibvsO5U7tvvDcgcmxK/kBZLLHCn5XaDPdvhyUobA6cfmOcz1Qzo
fN8SON/21cRYWhQk/4+cYZTW5PVgGEzwOzwxy2OnNoWF4La5l8kXUUFZspBA2OIN
9p3vX/Z387nGjCQA7GVEDC0JuVBVMAnHOfKlF6vpF/T/exQxDum7aKC6AjpIb5/c
5h1x0ieBVmIU+TTrhtndcshFRQSvJH0hSb4q2DcEWAwlFNtYf3KeWw6j6wiim8ai
bq02He/eum9L6Wv2jVABNpjO2weN0Ocw3WUDqbUxJk5oBzPoj+1ELCoU7Ahw9xj0
xdfVTqFWQSq1omarOu2X
=yUpp
-----END PGP SIGNATURE-----

--2VXyA7JGja7B50zs--

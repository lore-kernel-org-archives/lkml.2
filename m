Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2KVU5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:57:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2KVU5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:57:41 -0500
Date: Thu, 22 Nov 2012 21:57:33 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4 04/11] pwm: pwm-tiecap: Add device-tree binding
 support for APWM driver
Message-ID: <20121122205732.GB16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-5-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-5-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:pM87Pyjb9LCH2kK6ryt+VsBDci5Vtosyx0b9ZgZaqwS
 zX8dkvFjVeQq3xa8oqrePPzUcE0gDLSSImr6Sf5rdjjkj9cMUI
 JmwMXYOlcQozULpu4Ll63UX60tRbAOt6RYPXOf69ssrFo1ckGp
 m3iNA1GvNXxDGSJTi5syV1FLTLyZVbmq9nCYcPkXa7l+MzReX/
 keUEU4gwWg1Y2Pw/axVVsGhKLLKnc8BrTKw6sbaOF8PW3Cnsi2
 HZUYkHiUnaH2Xru2xFS5iWolWhhgv1MyKGcrWUTRVkWKkU3yoN
 Z8mMb9i0XXCTIJ7+bNXkM/xwxj9No/TwoA9ULwNA3/124B+L8+
 i078oKAlsJ1P6ej51tb/r7ltNGdRL9RRYdPw4QyhnPDB4b1zYZ
 4/J5ZFLY2xF5rwFzztGsTy6Q8MO6o7vgFKv9tYFpI64XLXz7ph
 /tAS4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 06:41:01PM +0530, Philip, Avinash wrote:
[...]
> +static const struct of_device_id ecap_of_match[] = {
> +	{
> +		.compatible	= "ti,am33xx-ecap",
> +	},

Same here, can be shorter by putting it on one line instead of three.

Thierry

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpG8AAoJEN0jrNd/PrOhaf4QAMCySG9oIcWyadnrDf+uEbVK
lc1jDrWL2HLEDc/ZWAyGnqUaO4NIyz7MM4bFcyOI7/6MqIxKZdxewKrT+o2UQ5Kk
Ubmr7GjiOoUbnGPuyy/e8B1BqfKByp7AdE0g/ju8OpKk2MP/OBvIfGsecWchkO/k
0mAWSo6anaVcTVjXvvfLfu+HJph0cnUDxMxGeUV2BRqclB3GWVs3rHxcSi9pPWTy
06OpPGPxIP/vB0tBZIf+45MsOK//lBQ0Y+QVAD9meGIsI5HcU06QxwNTHjayjaBO
bY4Svc2ugp03aiT/QZgQmivKeF9n4ZLOUOX9A5UNIE0YG8iWItk6bXcHq5l/L1Gj
MsjtzuR5DmqaiE9X8z2PAv6Zo5+E7eTF1sYiy16s2zOsTkhH8elbXDent7+ed6oY
yZ+6t6W/+Rq1fGEQsLrIqG4wU4iu1zf45+mW2LgbcqeXRkk1p7mqE38/2ob5DcQu
5XPzZqgq4tqy1bKHr7Up7iddjUSX8nQLi0i8DFoqolkZ9FrIT6jisCGapB7CxGIA
8VSkgg2+YaY+3x+yzhtRxVIqv7tG5Jsh/+z9qTuSM82m5CO9KxsZ785/QL6RFFcA
StmvZ7aRpk8fBq9JERp56fXPj6zaT996WWzgP7DRtIIW8kKUK06lzxwjzUQFr/Rk
5R1gy8pF+7SVYAZZQSEs
=0mxx
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--

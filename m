Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab2ENQWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:22:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54708 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab2ENQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:22:21 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Bluetooth: notify userspace of security level change
In-Reply-To: Your message of "Sun, 13 May 2012 03:20:07 -0300."
             <1336890007-10646-1-git-send-email-gustavo@padovan.org>
From: valdis.kletnieks@vt.edu
References: <1336849910-29064-2-git-send-email-gustavo@padovan.org>
            <1336890007-10646-1-git-send-email-gustavo@padovan.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1337012536_2289P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 May 2012 12:22:16 -0400
Message-ID: <15456.1337012536@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.52 mail-yw0-f52.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4FB1313B.0076,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1337012536_2289P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 May 2012 03:20:07 -0300, Gustavo Padovan said:

> It enables the userspace a security level change when the socket is
> already connected and create a way to notify the socket the result of the
> request. At the moment of the request the socket is made non writable, if
> the request fails the connections closes, otherwise the socket is made
> writable again, POLL_OUT is emmited.

What happens to in-flight data already written but not yet consumed?  I'm
smelling a possible race condition with data sent under the old level but
read under the new level....

--==_Exmh_1337012536_2289P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT7ExOAdmEQWDXROgAQIEXxAAvEkGmcWB3xSQnwxaG6YPP3bMreXbmyKv
sc3L0TJ49yyyfVXND63wLV+jpnhdmRfTg/YkPzUSdv5QM26bf7eN8xPHl7cNYsTW
/UzJmC3x+rb03ixjPWMAQFUwJ5LmB/Vm6VwkonMmgQRRgc0ICSrl+hQuBxO9vrbg
oldwJPTR/ILslBJzvfK6Mwv+hmXcDVa8X2UAFpN/dSGzwfV1vIcseuQSI/JXDKvN
b+UOX5zumHJFPIOhRqsS3FAYHsUbf8BWMFXuqfzQUbv4c+dd3V+OFKDQx11cHS5O
d3vNWvCoxKgZt3shD5j2wx8RCcz4qVlmwdvlnz+Vksmsn6HFyNdrxv0vSAwxlsPV
yPnzptcnotIWFjKD40IeKQb+SRmILLqlhosXTyYIkFWnYl7N3iZHfeh1ohMsYNtd
SMov/cOt91e0BB9iUw3FFRUEAkTnrkXdv+TehT5G7tEwtcTOWr3BPzaJIKlqs12Z
Our3yILTGFg1OvItS2zJ4j5XiXGxpTYCvRWSt+77nLAGg282PbKaZGniCYbQiZpv
MO5Makfc0EE0pUMaPTL8A753w+8P/mYGc0vJb/qCQ49HfaxteTjrle6SWapp0ZCU
8uBARtq2nPdWj/nu6KKf2BAmq1J/Ay1i8mjDWsauDwXE7yYahLvYQkDXm3JWBB9M
H685+ryqnJg=
=ofMS
-----END PGP SIGNATURE-----

--==_Exmh_1337012536_2289P--


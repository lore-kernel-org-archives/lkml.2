Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab2BJAy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:54:28 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51352 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2BJAy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:54:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: pohmelfs: call for inclusion
In-Reply-To: Your message of "Wed, 08 Feb 2012 23:12:54 +0300."
             <20120208201254.GD22215@ioremap.net>
From: Valdis.Kletnieks@vt.edu
References: <20120208193413.GA22215@ioremap.net> <20120208201008.GA5578@kroah.com>
            <20120208201254.GD22215@ioremap.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1328835255_2778P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Feb 2012 19:54:15 -0500
Message-ID: <4792.1328835255@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4F346ABC.00B4,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1328835255_2778P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Feb 2012 23:12:54 +0300, Evgeniy Polyakov said:

> +	tristate "POHMELFS distributed filesystem"
> +	depends on INET && EXPERIMENTAL
> +	select CRYPTO_HASH
> +	help
> +	  POHMELFS is a POSIX frontend to Elliptics network
> +
> +	  Elliptics is a key/value storage, which by default imlpements
typo fix:			implements
> +	  distributed hash table structure.

--==_Exmh_1328835255_2778P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBTzRqtwdmEQWDXROgAQIJAxAAp5hmaFju8c0tmb5otM2qM11mxulYyX40
AdcWW/a02eRjuySujZ01oG/Caq60PwJKq83A7orjVRTgssiZJIrBR32JJFRw56qd
72np9h68QnxtYd1EQuOc2Smqck4Al4yHdYXuayVvQq9gD0Q7wsgj56ATwNtmFY58
UH80GAMU2Ek9+V5OjYccQvh1t9AkoaqKvalPW176kCqA4nyLmO7iDgM2qYGIuYLx
WYfQgW4mnEO68VjbW5SgqkD27pqIUizdM/lnuc1xBSRJ0SlP553YS94KVPO2ZQsE
mlM8zIhZ7pBdIR+X8+Bh/1Z7NDN37ShdTP2MF1I4TgPi7SuhOlypLR8MlaTZzit9
sgx4gB4eFh7PBnjjG1ARxL7yzoue4DWtuAq8gc9/uiCi9e0uco3WFpUcT2GdwSe+
UCtk8Undg515t171QQQEbI6FAObOcXqBmsudo4p8G0UDi1T+C8reDgpe+oBK9Reb
bAspHa4pYlEAIWOQcK+j8WS9M42o9SklihBj1jLOWPnrI36Xp8YRWr+P907byAsi
Bk3yankSrcrf1LrMXdpYebTm9gl/b3qGynjyave8Jglk63zOauvN4d8frFqrgPC2
l13/TvYFHAwgZUf9FIpZLt0w1yERbKZPEDQbU8WqT65nDgK4GQpPb7qNx1UOCrPO
W/FlKD4jd5o=
=yXFj
-----END PGP SIGNATURE-----

--==_Exmh_1328835255_2778P--


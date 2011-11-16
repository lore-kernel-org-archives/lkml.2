Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab1KPAke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:40:34 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47756 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab1KPAkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:40:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RESEND #3 5/7] arm: omap: smartreflex: clean ups all over
In-Reply-To: Your message of "Tue, 15 Nov 2011 10:46:03 +0200."
             <1321346765-16633-6-git-send-email-balbi@ti.com>
From: Valdis.Kletnieks@vt.edu
References: <1321346765-16633-1-git-send-email-balbi@ti.com>
            <1321346765-16633-6-git-send-email-balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1321403991_2702P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Nov 2011 19:39:51 -0500
Message-ID: <22157.1321403991@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4EC30659.000C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1321403991_2702P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 Nov 2011 10:46:03 +0200, Felipe Balbi said:

> -	int				srid;
> -	int				ip_type;
> +	struct list_head		node;
> +	struct platform_device		*pdev;
> +	struct omap_sr_nvalue_table	*nvalue_table;
> +	struct voltagedomain		*voltdm;

As long as you're de-tabifying the function names that caused the problem...

>  	int				nvalue_count;
> -	bool				autocomp_active;
> -	bool				is_suspended;

Why are you leaveing the rest of the struct tabified out to East Podunk?

--==_Exmh_1321403991_2702P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOwwZXcC3lWbTT17ARAiLzAJ4u3ZBprGL4Syg8SoSZvvgb5FG9IgCeP1Op
JPvlZUB2nWmsyV34T7rqXxE=
=LBAG
-----END PGP SIGNATURE-----

--==_Exmh_1321403991_2702P--


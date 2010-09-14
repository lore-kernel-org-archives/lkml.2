Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0INRKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:10:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35776 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0INRKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:10:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: mjg59@srcf.ucam.org, randy.dunlap@oracle.com, mjg@redhat.com,
        gregkh@suse.de, trenn@suse.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis.Jansen@web.de,
        "Lee, Chun-Yi" <jlee@novell.com>
Subject: Re: [PATCH] Add Intel Poulsbo Stub Driver
In-Reply-To: Your message of "Tue, 14 Sep 2010 10:39:42 +0800."
             <1284431982-7750-1-git-send-email-jlee@novell.com>
From: Valdis.Kletnieks@vt.edu
References: <1284431982-7750-1-git-send-email-jlee@novell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284484217_4681P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Sep 2010 13:10:17 -0400
Message-ID: <14640.1284484217@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4C8FAC7A.01B0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284484217_4681P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Sep 2010 10:39:42 +0800, "Lee, Chun-Yi" said:
> 
> +        select ACPI_VIDEO if ACPI
> +	help
> +	  Choose this option if you have a system that has Intel Poulsbo
> +	  integrated graphics.

Can we have a part number or something here?  When I buy a system from Dell or
someplace, the spec sheet doesn't say 'Poulsbo', it says 'i945' or 'i987' or
something like that.

(If this is a not-yet-escaped-from-engineering new part, maybe a follow-up patch
when the part is officially named/announced?)


--==_Exmh_1284484217_4681P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMj6x5cC3lWbTT17ARAi1ZAKDlPv9TzTbaTPFFKnrXmYwO+BMh2QCgifvz
t/HuFh82oUpQTPlmpV1iyu0=
=9v27
-----END PGP SIGNATURE-----

--==_Exmh_1284484217_4681P--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab1DBUsC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 16:48:02 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42945 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab1DBUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 16:48:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, rja@sgi.com
Subject: Re: [PATCH v3] x86: UV kdump reboot fix
In-Reply-To: Your message of "Thu, 31 Mar 2011 09:32:02 CDT."
             <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
From: Valdis.Kletnieks@vt.edu
References: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1301777257_4705P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 02 Apr 2011 16:47:37 -0400
Message-ID: <45253.1301777257@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D978B6D.0073,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1301777257_4705P
Content-Type: text/plain; charset=us-ascii

On Thu, 31 Mar 2011 09:32:02 CDT, Cliff Wickman said:
> From: Cliff Wickman <cpw@sgi.com>
> 
> After a crash dump on an SGI Altix UV system the crash kernel fails to
> cause a reboot.  EFI mode is disabled in the kdump kernel, so only the
> reboot_type of BOOT_ACPI works.

> +	/*
> +	 * for a kdump kernel the reset must be BOOT_ACPI, not BOOT_EFI, as
> +	 * EFI is not enabled in the kdump kernel.
> +	 */
> +	if (is_kdump_kernel())
> +		reboot_type = BOOT_ACPI;
>  }

What happens if some bozo builds their own kdump kernel that has EFI enabled?

--==_Exmh_1301777257_4705P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNl4tpcC3lWbTT17ARAgeZAJ9Drj2aZr5u4ouceOeL7xVVrPCQQQCgxdv/
MUFJY77mlhNumvZLBNVctGg=
=95tv
-----END PGP SIGNATURE-----

--==_Exmh_1301777257_4705P--


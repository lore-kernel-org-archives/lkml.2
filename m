Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0KFBvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 21:51:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58344 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab0KFBu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 21:50:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: cdhmanning@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
In-Reply-To: Your message of "Thu, 04 Nov 2010 05:53:16 +1300."
             <1288803204-3849-2-git-send-email-cdhmanning@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
            <1288803204-3849-2-git-send-email-cdhmanning@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1289008258_4426P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Nov 2010 21:50:58 -0400
Message-ID: <10039.1289008258@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4CD4B482.013F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1289008258_4426P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Nov 2010 05:53:16 +1300, cdhmanning@gmail.com said:
> From: Charles Manning <cdhmanning@gmail.com>
> 
> Adding yaffs2 file system.

> +config YAFFS_DOES_ECC
> +	bool "Lets Yaffs do its own ECC"
> +	depends on YAFFS_FS && YAFFS_YAFFS1 && !YAFFS_9BYTE_TAGS
> +	default n
> +	help
> +	  This enables Yaffs to use its own ECC functions instead of using
> +	  the ones from the generic MTD-NAND driver.
> +
> +	  If unsure, say N.

Why does this exist at all? Are there any cases where the Yaffs ECC is better
than the MTD versions? If so, why aren't we fixing the MTD versions?

> +config YAFFS_DISABLE_TAGS_ECC
> +	bool "Disable YAFFS from doing ECC on tags by default"
> +	depends on YAFFS_FS && YAFFS_YAFFS2
> +	default n
> +	help
> +	  This defaults Yaffs to using its own ECC calculations on tags instead of
> +	  just relying on the MTD.
> +	  This behavior can also be overridden with tags_ecc_on and
> +	  tags_ecc_off mount options.
> +
> +	  If unsure, say N.

Similarly here - why would somebody want this?

> +config YAFFS_EMPTY_LOST_AND_FOUND
> +	bool "Empty lost and found on boot"
> +	depends on YAFFS_FS
> +	default n
> +	help
> +	  If this is enabled then the contents of lost and found is
> +	  automatically dumped at mount.

Wow.. Just.. wow.   Under what use case is this a good idea for a config option
as opposed to a mount option?



--==_Exmh_1289008258_4426P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM1LSCcC3lWbTT17ARAparAKCkdqmXdDgU5yaTIzZ3Z/D/KGBzbACg0RP8
T4FSkgZJB67XUFQ6wnz54Yg=
=FB6H
-----END PGP SIGNATURE-----

--==_Exmh_1289008258_4426P--


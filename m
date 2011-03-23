Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab1CWVnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:43:37 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55769 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1CWVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:43:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com,
        david@woodhou.se
Subject: Re: [PATCH 7/7] char/mei: Updates to char/Kconfig ane char/Makefile
In-Reply-To: Your message of "Tue, 22 Mar 2011 12:51:32 +0200."
             <1300791092-14319-8-git-send-email-oren.jer.weil@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
            <1300791092-14319-8-git-send-email-oren.jer.weil@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1300916607_5029P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Mar 2011 17:43:27 -0400
Message-ID: <29997.1300916607@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D8A6981.0088,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1300916607_5029P
Content-Type: text/plain; charset=us-ascii

On Tue, 22 Mar 2011 12:51:32 +0200, Oren Weil said:
> Changes of Kconfig and Makefile in driver/char
> for adding the Intel MEI Driver to the Linux kernel.
> New Makefile building for MEI Driver.

> +config INTEL_MEI
> +	tristate "Intel Management Engine Interface (Intel MEI)"
> +	depends on X86 && EXPERIMENTAL
> +	help
> +		The Intel Management Engine (Intel ME) provides Manageability,
> +		Security and Media services for system containing Intel chipsets.
> +		if selected /dev/mei misc device will be created.

Can we have this re-worded so it doesn't have an implied "all Intel chipsets",
perhaps adding "chipsets that support the Intel vPro technology", or similar?

(And though I found that at least *some* vPro-capable chipsets do IME, I didn't
find a statement that *all* vPro will do it, so I'm still confused, thus no
patch from me...)


--==_Exmh_1300916607_5029P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNiml/cC3lWbTT17ARAnNVAKCB5EpAA122KPvudWA4//TcpV/R5wCeKvMf
h+63T1Po5/Mhe3bstF8jZrM=
=Nu2x
-----END PGP SIGNATURE-----

--==_Exmh_1300916607_5029P--


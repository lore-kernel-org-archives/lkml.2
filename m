Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab1D0UtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:49:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36001 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1D0UtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:49:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: tim.gardner@canonical.com
Cc: wey-yi.w.guy@intel.com, Andi Kleen <andi@firstfloor.org>,
        donald.h.fry@intel.com, sgruszka@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
In-Reply-To: Your message of "Wed, 27 Apr 2011 11:42:46 MDT."
             <4DB85596.4070105@canonical.com>
From: Valdis.Kletnieks@vt.edu
References: <20110426212.641772347@firstfloor.org> <20110426211418.AF9B93E1886@tassilo.jf.intel.com>
            <4DB85596.4070105@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303937247_5269P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Apr 2011 16:47:27 -0400
Message-ID: <38255.1303937247@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DB880E1.00CD,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1303937247_5269P
Content-Type: text/plain; charset=us-ascii

On Wed, 27 Apr 2011 11:42:46 MDT, Tim Gardner said:
> On 04/26/2011 03:14 PM, Andi Kleen wrote:
> > 2.6.35-longterm review patch.  If anyone has any objections, please let me know.

> > From: Fry, Donald H<donald.h.fry@intel.com>
> >
> > commit 41504cce240f791f1e16561db95728c5537fbad9 upstream.
> >
> > New iwlwifi-5000 microcode requires driver support for API version 5.

> Will this cause any issues with the existing 2.6.35.12 iwl-5000 driver? 
> Is the version 5 API backwards compatible? Ubuntu installs 
> iwlwifi-5000-5.ucode by default in order to support compat-wireless 
> backports from 2.6.3[678], so I'd hate to break those folks that are 
> using the stock 2.6.35.y driver.

I can't speak to Ubuntu, but I hit this on Fedora Rawhide a while ago, they
ended including several versions so different kernels would work OK:

% rpm -ql iwl5000-firmware
/lib/firmware/iwlwifi-5000-1.ucode
/lib/firmware/iwlwifi-5000-2.ucode
/lib/firmware/iwlwifi-5000-5.ucode


--==_Exmh_1303937247_5269P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNuIDfcC3lWbTT17ARAoDhAJ9m19jnx9Ggnz3k9nsH3UYJ1fTPdwCgvYg0
46YxKTWNm3MDeE3V3YaAhQk=
=UuHY
-----END PGP SIGNATURE-----

--==_Exmh_1303937247_5269P--


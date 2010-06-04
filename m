Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0FDCYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:24:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35525 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab0FDCYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:24:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-03-16-36 uploaded
In-Reply-To: Your message of "Thu, 03 Jun 2010 16:36:51 PDT."
             <201006040005.o5405Afw023296@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275618190_4915P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jun 2010 22:23:11 -0400
Message-ID: <11930.1275618191@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C08638F.0190,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275618190_4915P
Content-Type: text/plain; charset=us-ascii

On Thu, 03 Jun 2010 16:36:51 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to

Not strictly a -mm problemn, but I just noticed it.

In drivers/idle/Kconfig, we see:

  Cpuidle Driver for Intel Processors (INTEL_IDLE) [N/m/y/?] (NEW) ?

CONFIG_INTEL_IDLE:

Enable intel_idle, a cpuidle driver that includes knowledge of
native Intel hardware idle features.  The acpi_idle driver
can be configured at the same time, in order to handle
processors intel_idle does not support.

I think we wanted a s/acpi_idle/processor_idle/ there?

--==_Exmh_1275618190_4915P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMCGOOcC3lWbTT17ARAl0fAKDOkA/h8lIlYu93PtKY4eb6qM0d8ACfR39s
0JG6aDGyIDXSl/j2kDAql94=
=iT9t
-----END PGP SIGNATURE-----

--==_Exmh_1275618190_4915P--


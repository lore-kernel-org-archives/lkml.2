Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab0ETPWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:22:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52829 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0ETPWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:22:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: mmotm 2010-05-19 - Kconfig dependency list from hell...
In-Reply-To: Your message of "Wed, 19 May 2010 16:13:09 PDT."
             <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1274368903_4237P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 20 May 2010 11:21:43 -0400
Message-ID: <38232.1274368903@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Info: (50) HELO_LOCALHOST,UPPERCASE_50_75
X-Junkmail-Status: score=50/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4BF55388.0222,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1274368903_4237P
Content-Type: text/plain; charset=us-ascii

On Wed, 19 May 2010 16:13:09 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-05-19-16-12 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Looks like some code to sort the dependency list and eliminate duplicates is
called for. I hit '?' on a new prompt, and saw this:

CONFIG_COMEDI_FC:

Enable support for shared functions for low-level drivers.
This module is not used directly by end-users. Rather, it
is used by many other comedi drivers.

To compile this driver as a module, choose M here: the module will be
called comedi_fc.

Symbol: COMEDI_FC [=n]
Prompt: Comedi shared functions for low-level driver support
  Defined at drivers/staging/comedi/Kconfig:1294
  Depends on: STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n]
  Location:
    -> Device Drivers
      -> Staging drivers (STAGING [=y])
        -> Exclude Staging drivers from being built (STAGING_EXCLUDE_BUILD [=n])

  Selected by: COMEDI_TEST [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n]
&& COMEDI_MISC_DRIVERS [=n] || COMEDI_DAS16M1 [=n] && STAGING [=y] &&
!STAGING_EXCLUDE_BUILD [=n] && COMEDI_ISA_DRIVERS [=n] && ISA [=n] ||
COMEDI_DAS16 [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_ISA_DRIVERS [=n] && ISA [=n] || COMEDI_DAS800 [=n] && STAGING [=y] &&
!STAGING_EXCLUDE_BUILD [=n] && COMEDI_ISA_DRIVERS [=n] && ISA [=n] ||
COMEDI_DAS1800 [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_ISA_DRIVERS [=n] && ISA [=n] || COMEDI_DT282X [=n] && STAGING [=y] &&
!STAGING_EXCLUDE_BUILD [=n] && COMEDI_ISA_DRIVERS [=n] && ISA [=n] ||
COMEDI_ADDI_APCI_3001 [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_PCI_DRIVERS [=n] && PCI [=y] || COMEDI_ADDI_APCI_3120 [=n] && STAGING
[=y] && !STAGING_EXCLUDE_BUILD [=n] && COMEDI_PCI_DRIVERS [=n] && PCI [=y] ||
COMEDI_ADL_PCI9111 [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_PCI_DRIVERS [=n] && PCI [=y] || COMEDI_ADL_PCI9118 [=n] && STAGING [=y]
&& !STAGING_EXCLUDE_BUILD [=n] && COMEDI_PCI_DRIVERS [=n] && PCI [=y] ||
COMEDI_AMPLC_PCI224 [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_PCI_DRIVERS [=n] && PCI [=y] || COMEDI_GSC_HPDI [=n] && STAGING [=y] &&
!STAGING_EXCLUDE_BUILD [=n] && COMEDI_PCI_DRIVERS [=n] && PCI [=y] ||
COMEDI_CB_PCIDAS64 [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_PCI_DRIVERS [=n] && PCI [=y] || COMEDI_CB_PCIDAS [=n] && STAGING [=y] &&
!STAGING_EXCLUDE_BUILD [=n] && COMEDI_PCI_DRIVERS [=n] && PCI [=y] ||
COMEDI_S626 [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_PCI_DRIVERS [=n] && PCI [=y] || COMEDI_NI_MIO_CS [=n] && STAGING [=y] &&
!STAGING_EXCLUDE_BUILD [=n] && COMEDI_PCMCIA_DRIVERS [=n] && PCMCIA [=y] &&
COMEDI_NI_TIO [=n] && COMEDI_NI_COMMON [=n] || COMEDI_USBDUXFAST [=n] &&
STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] && COMEDI_USB_DRIVERS [=n] && USB
[=y] || COMEDI_NI_LABPC [=n] && STAGING [=y] && !STAGING_EXCLUDE_BUILD [=n] &&
COMEDI_NI_COMMON [=n]

(Last line wrapped for readability). That includes these dups:

     19  !STAGING_EXCLUDE_BUILD [=n]
     18  STAGING [=y]
      9  COMEDI_PCI_DRIVERS [=n]
      5  COMEDI_ISA_DRIVERS [=n]

It would probably be harder to reduce these:

      1  PCI [=y] || COMEDI_S626 [=n] 
      1  PCI [=y] || COMEDI_NI_MIO_CS [=n] 
      1  PCI [=y] || COMEDI_GSC_HPDI [=n] 
      1  PCI [=y] || COMEDI_CB_PCIDAS64 [=n] 
      1  PCI [=y] || COMEDI_CB_PCIDAS [=n] 
      1  PCI [=y] || COMEDI_AMPLC_PCI224 [=n] 
      1  PCI [=y] || COMEDI_ADL_PCI9118 [=n] 
      1  PCI [=y] || COMEDI_ADL_PCI9111 [=n] 
      1  PCI [=y] || COMEDI_ADDI_APCI_3120 [=n] 
      1  ISA [=n] || COMEDI_DT282X [=n] 
      1  ISA [=n] || COMEDI_DAS800 [=n] 
      1  ISA [=n] || COMEDI_DAS1800 [=n] 
      1  ISA [=n] || COMEDI_DAS16 [=n] 
      1  ISA [=n] || COMEDI_ADDI_APCI_3001 [=n] 

(Is there a reason these don't print with () around them?  It looks like it
needs them to enforce proper semantics...)





--==_Exmh_1274368903_4237P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL9VOHcC3lWbTT17ARAoiBAKDwrqLYAMeJVqXixRkdH4KnIAeUjACeO+qi
vn1gxJFZjK6XgeBgtFm52S8=
=yofM
-----END PGP SIGNATURE-----

--==_Exmh_1274368903_4237P--


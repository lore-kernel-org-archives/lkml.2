Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0ISNGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 09:06:37 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:38619
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753406Ab0ISNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 09:06:35 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz936eK1432N98dNzz1202hzz8275bh8275dh15d4Rz32i2a8h34h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8ZWED-02-IY1-02
X-M-MSG: 
Date: Sun, 19 Sep 2010 15:09:06 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: "Brown, Len" <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "borislav.petkov@" <amd.com.borislav.petkov@amd.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: 7ad6e9435596f692ff65f399da12816c94960185 breaks AMD f10h.
Message-ID: <20100919150906.6aab3d50@marah.osrc.amd.com>
In-Reply-To: <1284855246.32373.291.camel@yhuang-dev>
References: <20100917145625.75d2a412@marah.osrc.amd.com>
	<1284855246.32373.291.camel@yhuang-dev>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/9Q_cnYCPGap=.ajzq0gFdzi";
	protocol="application/pgp-signature"
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9Q_cnYCPGap=.ajzq0gFdzi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Sep 2010 20:14:06 -0400
Huang Ying <ying.huang@intel.com> wrote:

>Hi, Conny,
>
>On Fri, 2010-09-17 at 20:56 +0800, Conny Seidel wrote:
>> Hi,
>>
>> Kernel v2.6.36-rc4-134-g03a7ab0 breaks with the OOPS below.
>>
>> Reverting the commitid in the subject fixes the issue.
>> This is because APEI is selected by default on X86 (X86 && ACPI),
>> maybe a vendor check in the hest_init() might make sense.
>
>It seems that Dongming has reported and fixed this BUG. Please try this
>fixes:
>
>http://lkml.org/lkml/2010/9/2/52
>
>Hi, Len,
>
>Can you apply the BUG FIX?
>
>Best Regards,
>Huang Ying
>
>
The fix is working, thanks a lot.

Conny



##
##################################################################
# Email : conny.seidel@amd.com            GnuPG-Key : 0xA6AB055D #
# Fingerprint: 17C4 5DB2 7C4C C1C7 1452 8148 F139 7C09 A6AB 055D #
##################################################################
# Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach      #
# General Managers: Alberto Bozzo, Andrew Bowd                   #
# Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen #
#               HRB Nr. 43632                                    #
##################################################################

--Sig_/9Q_cnYCPGap=.ajzq0gFdzi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyWC3IACgkQ8Tl8CaarBV2QCgCg6XbVD7SMy0l1wq/ytQEehfFq
jzQAoOxmJH8GfC6k4QG57sUPwwOAXbcA
=n+Gz
-----END PGP SIGNATURE-----

--Sig_/9Q_cnYCPGap=.ajzq0gFdzi--

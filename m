Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0GFIlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:41:35 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:57948
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab0GFIle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:41:34 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jul 2010 04:41:34 EDT
X-SpamScore: -24
X-BigFish: VPS-24(zz1432N98dN4015L7cf0izz1202hzz15d4Rz32i2a8h34h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L54NFE-02-1NZ-02
X-M-MSG: 
Date: Tue, 6 Jul 2010 10:31:03 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Petkov, Borislav" <Borislav.Petkov@amd.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/5] perf tools: Fix fallback to cplus_demangle() when
 bfd_demangle() is not available
Message-ID: <20100706103103.3b22f53a@marah.osrc.amd.com>
In-Reply-To: <20100706065904.GC16224@elte.hu>
References: <1278378276-25872-1-git-send-email-acme@infradead.org>
	<1278378276-25872-2-git-send-email-acme@infradead.org>
	<20100706065904.GC16224@elte.hu>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei =?UTF-8?B?TcO8bmNoZW47IEdlc2Now6RmdHNmw7xocmVyOg==?= Alberto Bozzo,
 Andrew Bowd; Sitz: Dornach, Gemeinde Aschheim, Landkreis =?UTF-8?B?TcO8?=
 =?UTF-8?B?bmNoZW47?= Registergericht =?UTF-8?B?TcO8bmNoZW4s?= HRB Nr. 43632
X-Mailer: Claws Mail 3.7.6cvs11 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/0DPN8HL7wbAXpB2r1VH29u2";
	protocol="application/pgp-signature"
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0DPN8HL7wbAXpB2r1VH29u2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Jul 2010 02:59:04 -0400
Ingo Molnar <mingo@elte.hu> wrote:

>
>* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
>
>> From: Conny Seidel <conny.seidel@amd.com>
>>
>> make version 3.80 doesn't support "else ifdef" on the same line,
>> also it doesn't support unindented nested constructs.
>>
>> Build fails with:
>> Makefile:608: Extraneous text after `else' directive
>> Makefile:611: *** only one `else' per conditional.  Stop.
>>
>> This patch fixes the build for make 3.80.
>
>Since 3.81 is the latest Make version and 3.80 is just one step before
>that, shouldnt we cherry-pick this into perf/urgent? (or is current
>upstream unaffected?)

Current upstream is also affected. So it makes sense to put it in
perf/urgent.

>Thanks,
>
>	Ingo
>

regards,
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

--Sig_/0DPN8HL7wbAXpB2r1VH29u2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwy6ccACgkQ8Tl8CaarBV1pewCfXklSsOauIT9FpwEMiU6zQH0n
D1EAoLLsGZgtazE5t0hEkSU7gXYofEHl
=hAQQ
-----END PGP SIGNATURE-----

--Sig_/0DPN8HL7wbAXpB2r1VH29u2--

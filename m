Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0I1R0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:26:52 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:32244
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab0I1R0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:26:50 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 13:26:50 EDT
X-SpamScore: -28
X-BigFish: VPS-28(zzbb2cK1432N98dN4015Lzz1202hzz8275bh15d4Rz32i2a8h34h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,0,
X-WSS-ID: 0L9GVQ7-02-S8L-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 19:14:28 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Jan Beulich <JBeulich@novell.com>
CC: "borislav.petkov" <borislav.petkov@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: current TIP/master doesn't build on SLES10
Message-ID: <20100928191428.7696d681@marah.osrc.amd.com>
In-Reply-To: <4CA22F1D020000780001961F@vpn.id2.novell.com>
References: <20100928163136.7a2355d0@marah.osrc.amd.com>
	<4CA22F1D020000780001961F@vpn.id2.novell.com>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/jyNj69oHG+wv6oNC_99rpQ7";
	protocol="application/pgp-signature"
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jyNj69oHG+wv6oNC_99rpQ7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Sep 2010 12:08:29 -0400
Jan Beulich <JBeulich@novell.com> wrote:

>>>> On 28.09.10 at 16:31, Conny Seidel <conny.seidel@amd.com> wrote:
>> Hi
>>
>> compiling TIP/master (44bc8c4f500fce7263803b4acd016fa03cf8a91a) on
>> SLES10 fails with the following build error:
>>
>> arch/x86/kernel/entry_64.S: Assembler messages:
>> arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
>> arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
>> make[2]: *** [arch/x86/kernel/entry_64.o] Error 1
>> make[1]: *** [arch/x86/kernel] Error 2
>> make: *** [arch/x86] Error 2
>>
>> I've bisected it to commit df5d1874ce1a1f0e0eceff4fa3a9d45620243a68.
>>
>> Reverting it fixes the issue.
>>
>> I know that this is caused by binutils 2.16.91.0.5 which is distributed
>> with SLES10.
>
>I'm generally doing almost all of my work on SLE10, and have not run
>into this issue. Are you sure you've got it fully updated?
>
>Jan

Just for the record:
The binutils from SLES10 SP3 (2.16.91.0.5-23.34.33) have fixed the build
issue for me.

Thanks,
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

--Sig_/jyNj69oHG+wv6oNC_99rpQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyiInUACgkQ8Tl8CaarBV2FQwCePdIXNIeJuEc2DE2Zb8i9k9OC
G/4AnRvlEVaOsuoFfBPL+cMoloEJuEnj
=a+AG
-----END PGP SIGNATURE-----

--Sig_/jyNj69oHG+wv6oNC_99rpQ7--

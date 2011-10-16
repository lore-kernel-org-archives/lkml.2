Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1JPWHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 18:07:13 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:46126
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab1JPWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 18:07:11 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432N98dKzz1202hzz15d4R8275eh8275bh8275dha1495iz32i668h839h34h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LT6IRK-01-8Q7-02
X-M-MSG: 
Date: Mon, 17 Oct 2011 00:07:59 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Borislav Petkov <bp@amd64.org>
CC: Tejun Heo <tj@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:1239
 setup_local_APIC+...
Message-ID: <20111017000759.3d1f4310.conny.seidel@amd.com>
In-Reply-To: <20111015221215.GA25519@aftab>
References: <20111014135516.GC11990@aftab>
	<20111014165604.GA14286@aftab>
	<20111014175556.GE4294@google.com>
	<20111015221215.GA25519@aftab>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo; Sitz: Dornach, Gemeinde
 Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
X-Mailer: Claws Mail 3.7.10cvs27 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/DoVO_yTpAWXZU.ztfR4FwUL";
	protocol="application/pgp-signature"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DoVO_yTpAWXZU.ztfR4FwUL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Oct 2011 18:12:15 -0400
Borislav Petkov <bp@amd64.org> wrote:

>On Fri, Oct 14, 2011 at 01:55:56PM -0400, Tejun Heo wrote:
>> Jan hit similar problem a while back.
>>
>>   http://thread.gmane.org/gmane.linux.kernel/1180954
>>
>> I can't seem to find the patch in mainline.  Jan, Ingo?  Borislav,
>> would the patch there resolve the warning you're seeing too?
>
>There's even a -v2 at
>http://marc.info/?l=3Dlinux-kernel&m=3D131722471001895
>
>We'll run that one to test.

Looks good. The warning is gone.

>> Anyways, to summarize, the early apic thing isn't necessary anymore
>> and can be ripped out and the warning is pretty much bogus at this
>> point.  I'll rip it out soonish.
>
>Ok, thanks.
>


--
regards,
Conny Seidel

##################################################################
# Email : conny.seidel@amd.com            GnuPG-Key : 0xA6AB055D #
# Fingerprint: 17C4 5DB2 7C4C C1C7 1452 8148 F139 7C09 A6AB 055D #
##################################################################
# Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach      #
# General Managers: Alberto Bozzo                                #
# Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen #
#               HRB Nr. 43632                                    #
##################################################################

--Sig_/DoVO_yTpAWXZU.ztfR4FwUL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6bVb8ACgkQ8Tl8CaarBV2MGgCgwt5Iy8TkPHfey9tdMSAptz1Q
5cwAnA+Z6+TXcDIDA2S/lc+NpEtc4qjM
=zppD
-----END PGP SIGNATURE-----

--Sig_/DoVO_yTpAWXZU.ztfR4FwUL--

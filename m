Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2IXSOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:14:39 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:22820
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757174Ab2IXSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:14:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh1be0I1432Id6f1izz1202h1d1ah1d2ahzz8275bh8275dh15d4Iz2dh668h839hd24he5bhf0ah107ah1288h12a5h12bdh137ah139eh34h1155h)
X-WSS-ID: 0MAV9C4-02-9GX-02
X-M-MSG: 
Date: Mon, 24 Sep 2012 20:16:50 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Borislav Petkov <bp@amd64.org>, Jan Kara <jack@suse.cz>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: divide error: bdi_dirty_limit+0x5a/0x9e
Message-ID: <20120924201650.6574af64.conny.seidel@amd.com>
In-Reply-To: <20120924143609.GH22303@aftab.osrc.amd.com>
References: <20120924102324.GA22303@aftab.osrc.amd.com>
	<20120924142305.GD12264@quack.suse.cz>
	<20120924143609.GH22303@aftab.osrc.amd.com>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo; Sitz: Dornach, Gemeinde
 Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
X-Mailer: Claws Mail 3.8.1cvs53 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/43nlnw0jZPor8M=ZYFfSof7";
	protocol="application/pgp-signature"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/43nlnw0jZPor8M=ZYFfSof7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 24 Sep 2012 16:36:09 +0200
Borislav Petkov <bp@amd64.org> wrote:
>[ =E2=80=A6 ]
>
>Conny, would you test pls?

Sure thing.
Out of ~25 runs I only triggered it once, without the patch the
trigger-rate is higher.

[   55.098249] Broke affinity for irq 81
[   55.105108] smpboot: CPU 1 is now offline
[   55.311216] smpboot: Booting Node 0 Processor 1 APIC 0x11
[   55.333022] LVT offset 0 assigned for vector 0x400
[   55.545877] smpboot: CPU 2 is now offline
[   55.753050] smpboot: Booting Node 0 Processor 2 APIC 0x12
[   55.775582] LVT offset 0 assigned for vector 0x400
[   55.986747] smpboot: CPU 3 is now offline
[   56.193839] smpboot: Booting Node 0 Processor 3 APIC 0x13
[   56.212643] LVT offset 0 assigned for vector 0x400
[   56.423201] Got negative events: -25

The Divide error wasn't triggered with the patch applied.


--
Kind regards.

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

--Sig_/43nlnw0jZPor8M=ZYFfSof7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBgo5MACgkQ8Tl8CaarBV3cIACfS8zIzyGd/CwVRbjaxJPGWaS6
DKgAn2p0sHybxD+L7HqOmxp59ejajOWd
=Z6fT
-----END PGP SIGNATURE-----

--Sig_/43nlnw0jZPor8M=ZYFfSof7--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1KFRdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:33:55 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:57668 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1KFRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:33:54 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Nov 2011 12:33:54 EST
Message-ID: <4EB6C299.7000404@web.de>
Date: Sun, 06 Nov 2011 18:23:37 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6B385.4070804@web.de> <CAOJsxLH5Vgk7tyr=RAEc=S2JhZ7n2JxOiUL9L91P_Bey+AuFUA@mail.gmail.com> <4EB6B83E.8050002@web.de> <alpine.LFD.2.02.1111061906440.1646@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1111061906440.1646@tux.localdomain>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF72C2A46B3B2CFECB9EE8078"
X-Provags-ID: V02:K0:dZ8X0c2sDJC8KBvdG5t1CjwzSLzmGroqztDpqIqv2JC
 i3aX/nNWQRgeTgRfzoQpSSvnkb5p8AQmUtwLsxGF66UNpyhJcb
 em7UlXhcoEZJ6H2UJn+pvfXtkRaBluiUUAiitdM67Lug2nEPn9
 pGUZqHC1TQhVu3vpzu328uifz8ZaNpSF4kE9I5h45Mb2AlXC5F
 Ex2aymQ0GTV4Ix8XQNjAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF72C2A46B3B2CFECB9EE8078
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-11-06 18:11, Pekka Enberg wrote:
> On Sun, 6 Nov 2011, Jan Kiszka wrote:
>>> Can you please share your kernel .config with me and I'll take a look=

>>> at it. We now have a "make kvmconfig" makefile target for enabling al=
l
>>> the necessary config options for guest kernels. I don't think any of
>>> us developers are using SUSE so it can surely be a KVM tool bug as
>>> well.
>>
>> Attached.
>=20
> It hang here as well. I ran
>=20
>   make kvmconfig
>=20
> on your .config and it works. It's basically these two:
>=20
> @@ -1478,7 +1478,7 @@
>  CONFIG_NETPOLL=3Dy
>  # CONFIG_NETPOLL_TRAP is not set
>  CONFIG_NET_POLL_CONTROLLER=3Dy
> -CONFIG_VIRTIO_NET=3Dm
> +CONFIG_VIRTIO_NET=3Dy
>  # CONFIG_VMXNET3 is not set
>  # CONFIG_ISDN is not set
>  # CONFIG_PHONE is not set
> @@ -1690,7 +1690,7 @@
>  # CONFIG_SERIAL_PCH_UART is not set
>  # CONFIG_SERIAL_XILINX_PS_UART is not set
>  CONFIG_HVC_DRIVER=3Dy
> -CONFIG_VIRTIO_CONSOLE=3Dm
> +CONFIG_VIRTIO_CONSOLE=3Dy
>  CONFIG_IPMI_HANDLER=3Dm
>  # CONFIG_IPMI_PANIC_EVENT is not set
>  CONFIG_IPMI_DEVICE_INTERFACE=3Dm
>=20
>             Pekka

Doesn't help here (with a disk image).

Also, both dependencies make no sense to me as we boot from disk, not
from net, and the console is on ttyS0.

Jan


--------------enigF72C2A46B3B2CFECB9EE8078
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk62wpkACgkQitSsb3rl5xTadACeOJs8Ipc2Ho1YkAiXP6V7QUIZ
C0IAoO9RKUinNkIhSE7Grxc1QXIDLUoZ
=xjxF
-----END PGP SIGNATURE-----

--------------enigF72C2A46B3B2CFECB9EE8078--

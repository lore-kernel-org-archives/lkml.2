Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1KFQT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:19:27 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:44096 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1KFQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:19:26 -0500
Message-ID: <4EB6B385.4070804@web.de>
Date: Sun, 06 Nov 2011 17:19:17 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
In-Reply-To: <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9C8028307C8890E53925920B"
X-Provags-ID: V02:K0:4f93e9DR0jjDNOMo7B08MJ7OqsO+Y0Qw/ENGLMG+OXB
 Vqev9ELfWp507c6YGb1MOpvfuhX3FlzN2DcmJLo1JOgy/EzuT6
 LMAzDx9pstS9sCGW8K6d9y1qTRwrS81nm06WL3u1kZMA2gUXaC
 mx4pBQT9WyJgpK1rP/hiN1PhlhzGC7WG3L18KVGxwNMCOTSbb/
 CZyi4AN6In2DxdGDb6B5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9C8028307C8890E53925920B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-11-06 14:06, Pekka Enberg wrote:
> Sure. I think it's mostly people that are interested in non-Linux
> virtualization that think the KVM tool is a pointless project.
> However, some people (including myself) think the KVM tool is a more
> usable and hackable tool than QEMU for Linux virtualization.

"Hackable" is relative. I'm surly not saying QEMU has nicer code than
kvm-tool, rather the contrary. But if it were that bad, we would not
have hundreds of contributors, just in the very recent history.

"Usable" - I've tried kvm-tool several times and still (today) fail to
get a standard SUSE image (with a kernel I have to compile and provide
separately...) up and running *). Likely a user mistake, but none that
is very obvious. At least to me.

In contrast, you can throw arbitrary Linux distros in various forms at
QEMU, and it will catch and run them. For me, already this is more usable=
=2E

Jan

*) kvm run -m 1000 -d OpenSuse11-4_64.img arch/x86/boot/bzImage \
	-p root=3D/dev/vda2
=2E..
[    1.772791] mousedev: PS/2 mouse device common for all mice
[    1.774603] cpuidle: using governor ladder
[    1.775490] cpuidle: using governor menu
[    1.776865] input: AT Raw Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    1.778609] TCP cubic registered
[    1.779456] Installing 9P2000 support
[    1.782390] Registering the dns_resolver key type
[    1.794323] registered taskstats version 1

=2E..and here the boot just stops, guest apparently waits for something


--------------enig9C8028307C8890E53925920B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk62s4UACgkQitSsb3rl5xS6swCfbqf+oVjR1BTjrnBP2Us+L5wc
fngAn2c1SM/IbkqIA6RynBFc6aP2MUAr
=cSMn
-----END PGP SIGNATURE-----

--------------enig9C8028307C8890E53925920B--

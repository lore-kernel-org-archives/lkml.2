Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1J0OCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:02:08 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46781 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab1J0OCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:02:06 -0400
Date: Thu, 27 Oct 2011 10:02:02 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: ext4 tree back to kernel.org
Message-ID: <20111027140202.GD31921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

I've actually been updating both kernel.org and github for a week or
so, this is probably a good time as any to ask that linux-next swtich
to tracking the dev branch at:

	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

Thanks,

						- Ted
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJOqWRaAAoJENNvdpvBGATwx+kP/2zHjAaIHsTk0pP5uBCXpuBZ
m4SZOOOMtnVXzBmk60c2CbGxIBR/EEJn5Mj/U6Q5RiutAlgdmpo/6iRxFEROOWyP
Yun6mP5tdcQ1v5C+3vYJZuDDEuJLs8gMtDCJqL1XzE8TahgIJWxn0/ewyJexmWUf
9jJk2VR516a2+aCs2CMJxRjYHO0FS/H7R1b4NP0UTroHnKl8CJqNJ0mH3om4N6Cw
ADIgPqg1erk6iJeUZFOPJPhXQT4U3+VZ4/CicMfg/kQ3UnLue4zcpHdXp0H+mg3Y
mXMV+9+n7Kyd7d8jB//bDIo7CHgq0RqoBobqca+fDR5yXY1VEMZDPMd+PX0Q9XUJ
cQxVdcuOV2YMQV/9sSg9tOTxH6y2YOSwqWl+hU+snZaGEdad/CFJkRQUBgsHmG4L
1B2HqsLhDW+Wg2EVrkctfn8wtLkrOCEFeHrHTrBV3EIEyQIgZRffZ6k/29/wUoEL
nTPNYQkYW42J+TmeJYKsWwViilerHUPDy7hWaqrBZVP6a6hmcQmK5RW0yTXZP/ke
Dt7H8lIzXYreFkEdHGr1ZwIidAswykL+r1738knRFy+tYJ70sAPt5pboT0WNJreT
TzYakK2FRy9PGply5VKLaSuoP4Hir9HvEK5LHgG+f9QKDtzs7aKM+TbRsndV7ImR
0vgW3lCpfl5jU1hKVQsR
=Imwu
-----END PGP SIGNATURE-----

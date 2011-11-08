Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1KHObX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:31:23 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:37684 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1KHObU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:31:20 -0500
X-Greylist: delayed 2844 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 09:31:20 EST
Date: Tue, 8 Nov 2011 14:43:45 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
Message-ID: <20111108144345.7555fa01@x220>
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b6yLHlTaH=MUISvRcvdsQbq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b6yLHlTaH=MUISvRcvdsQbq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Nov 2011 18:10:02 -0800 Linus Torvalds (LT) wrote:

LT> Have fun, give it a good testing. There shouldn't be anything hugely
LT> scary in there, but there *is* a lot of stuff. The fact that 3.1
LT> dragged out did mean that this ended up being one of the bigger merge
LT> windows, but I'm not feeling *too* nervous about it.

Hi,

The formatting of /proc/misc broke for cpu_dma_latency. This causes programs
reading from /proc/misc to complain. For example:

cryptsetup luksClose /dev/sdX
/proc/misc: No entry for device-mapper found
Is device-mapper driver missing from kernel?

With Linux 3.2-rc1:
 60 network_throughput
 61 network_latency
 62=20
236 device-mapper
237 loop-control
175 agpgart
144 nvram
231 snapshot
184 microcode
227 mcelog
 63 vga_arbiter

With Linux 3.1:
 60 network_throughput
 61 network_latency
 62 cpu_dma_latency
236 device-mapper
237 loop-control
175 agpgart
144 nvram
231 snapshot
184 microcode
227 mcelog
 63 vga_arbiter

Cheers,

	- Udo

--Sig_/b6yLHlTaH=MUISvRcvdsQbq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk65MhEACgkQnhRzXSM7nSnD3wCfTIuIfXldG/AH3jVmf0N44vgf
VBkAn3fcgAnx0muKcQowBLe7OiK8nkRh
=WuZg
-----END PGP SIGNATURE-----

--Sig_/b6yLHlTaH=MUISvRcvdsQbq--

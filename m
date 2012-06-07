Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2FGWDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:03:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:50400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab2FGWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="153147216"
Message-ID: <4FD12512.1010005@gmail.com>
Date: Thu, 07 Jun 2012 15:02:58 -0700
From: Jeff Kirsher <tarbal@gmail.com>
Reply-To: jeffrey.t.kirsher@intel.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jeffrey.t.kirsher@intel.com, rkagan@parallels.com, stable@vger.kernel.org,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        dnelson@redhat.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000: save skb counts in TX to avoid cache misses
References: <b838d871c0d507787373061e4edd91a624d62475.1339073391.git.rkagan@parallels.com> <4FD11F49.5060805@gmail.com> <20120607.144358.1732928576389957779.davem@davemloft.net>
In-Reply-To: <20120607.144358.1732928576389957779.davem@davemloft.net>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig038063C610A34E6E1F72D3E7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig038063C610A34E6E1F72D3E7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/07/2012 02:43 PM, David Miller wrote:
> From: Jeff Kirsher <tarbal@gmail.com>
> Date: Thu, 07 Jun 2012 14:38:17 -0700
>
>> Thanks! I have applied the patch to my queue
> Why?
>
> My impression is that this is a patch already in the tree, and it's
> being submitted for -stable but such minor performance hacks are
> absolutely not appropriate for -stable submission.
I did not catch that Roman was trying to get this into stable because
there was no mention of what stable kernels this was applicable back to
(and the fact that it was a performance).

I thought he had found an issue with the previous commits and was
suggesting a fix to the previous patches.

Since he is trying to get this into -stable, disregard my statement
about adding it to my tree.


--------------enig038063C610A34E6E1F72D3E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJP0SUSAAoJEOVv75VaS+3OSDsP/3oAiEaOuT5bmKZz3LA4kPOL
5jFtTeHccAGz9d2gKVCuN4D+9jHmCj7SslZNRAMncKaEVsoRbo5sMpkucjLBF6xg
nQTRNIMRh/MGSlG2Cw+T4h9Ci+rXmP4FtrJs2At7jE+9j5dFI3OefNoeP68boivt
2RQ1EbjCFYizwTNY+B5V2tOSwIJf/lmAUTAdyYBP7iS9ybVlrHmlQ8Yi7v6sze2P
oNflAJclfniixhlb6WBvN+p5HaQpxtAJZxIGUwPBKBX/5hSn5kJT88dqClPWx8LP
XltYtLHzyOE69Ic/7ngfXfOawCt+SFzt2Wl9vqQ7cWKAG2gCy5B8ki5G4N0GCb2b
vME3sNGL/XRS+64CAoPdbuS+9gSo/ZRQvlDTF2FC5ZsHHmd4jogQQJPyktT11wHg
TsKykz6o0hx0Gi3eF/7XSfqEG2FibKStFYTv53G7s9GmonlO8VjSxVPRTkG7trX+
u+KCFb13KAVp1vhmVMbiQeNlpXkcy9LFp3cJJ30+11lxO26IB6avTtsDFFPRcB5M
PYcvFPcdjNmUP7eb6TsN7KxmTJy8+NWxhlX4H2+nLILXEEhkZsvkkCQdh8L2xzdC
Ko547FeSIYtwIDL+RChfNde7DQ/F9UdEMUH02QDt7svSD0wZH55Dn5mi8ob4lcRW
ICow6BS8OCtB2nJNma0M
=XJMR
-----END PGP SIGNATURE-----

--------------enig038063C610A34E6E1F72D3E7--

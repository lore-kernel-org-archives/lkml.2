Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2EVIGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:06:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58477 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2EVIGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:06:42 -0400
Date: Tue, 22 May 2012 18:06:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] signals, the first series
Message-Id: <20120522180635.93ba83a63481b2364bd8f425@canb.auug.org.au>
In-Reply-To: <20120522043525.GI11775@ZenIV.linux.org.uk>
References: <20120522043525.GI11775@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_18_06_35_+1000_Ynd5BABzdoEZjyFn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_18_06_35_+1000_Ynd5BABzdoEZjyFn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,, Linus,

On Tue, 22 May 2012 05:35:25 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> 	This is just the first part of the queue (about a half of it);
> assorted fixes all over the place in signals' handling.  This one ends
> with all sigsuspend() implementations switched to generic one
> (->saved_sigmask-based), a bunch of assorted old buglets fixed and most
> of the missing bits of NOTIFY_RESUME hookup in place (two more sit in
> arm and um trees resp. and there's a couple of broken ones that need
> obvious fixes - parisc and avr32 check TIF_NOTIFY_RESUME only on one of
> two codepaths; that'll go in the next series).  Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git for-linus

I am pretty sure that none of this has been in linux-next ... I have no
idea what sort of conflicts it will produce with the rest of the code in
there or what issues that giving it some time in linux-next may discover.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_18_06_35_+1000_Ynd5BABzdoEZjyFn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPu0kLAAoJEECxmPOUX5FElvUP/RScUgSHnSML+gbHLEHdCw6r
qnLFN9LmXTGHuZSD79/0JfFANV4sy9Jwe0ZIewiD/ZaEVkN1XPYQQxi8iLrPaPvG
l0wevPzekoCTj9XThW5DACtxEDMNJobJ5pjuMzcyDVVQg1ieUeA3YjHufSj0pPV6
uctf5Kd7C4d66KDdP1iijcNVMoJXgHdMlgyBLlQlQlY3CRq0ybhJ6g7ajDvJcsg+
4/d7GRCbDWeJgH1ZJDdqqRsjhU8LFesLZr5/f6Kf/f7ctpy8hmJ8jd4MGZpQ+lup
03AKzQZctzhTxwUGh5bcxsrjGx3wfgMTSaIZHZGLC51uGH1rwSr02+wyvkwQs77S
fICv6zIUm1AN8N7IQXzR6RblIdGNC1mAHuN3+5MahHzcVp9qnkuCRAsR2hNikAJY
EGl8uwBVRcEZs+1QwZXYeRiUTR25BYNKJhH/DByF2KWeMCjgRAl314pmMS1WSnva
UFou4pSrItYLONa6OETFYrKI6PLYBhHku5gRHRZ6Sw7zAEsd8WFkXFXorG+2IwUA
2yVZ3DQYnsaKmgMjOzCoNkXacBATHareQKYx9Ki+ySMEpmG6wN5MCMzKmRBGrIm/
ABqJgqYeyacfMPCgnl8uzJJAl9oqPF4Gvp3DFW2BgENjaVFHmhS6reS0C6ArBLcK
mrzCsHZKLuuGe6UewXAt
=jWyu
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_18_06_35_+1000_Ynd5BABzdoEZjyFn--

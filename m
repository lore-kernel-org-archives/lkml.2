Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab2BQCpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:45:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59110 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2BQCpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:45:50 -0500
Date: Fri, 17 Feb 2012 13:45:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, apw@canonical.com, arjan@linux.intel.com,
        fhrbata@redhat.com, john.johansen@canonical.com,
        penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com,
        rusty@rustcorp.com.au, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] make vfork() killable
Message-Id: <20120217134537.d1ad20de8b048916fbd4eb0a@canb.auug.org.au>
In-Reply-To: <20120216162602.386cadf9.akpm@linux-foundation.org>
References: <20120214164709.GA21178@redhat.com>
	<20120214164914.GF21185@redhat.com>
	<20120215123049.6e938eed.akpm@linux-foundation.org>
	<20120216150429.GB11953@redhat.com>
	<20120216172626.GA30393@redhat.com>
	<20120216162602.386cadf9.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_13_45_37_+1100_fc=xsDdMl9m=u7BE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_13_45_37_+1100_fc=xsDdMl9m=u7BE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 16 Feb 2012 16:26:02 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> hum.  Via which tree did they get into linux-next and why did they not
> get any further?

They were in the ptrace tree from Aug 26 last year ... they were still
there on Oct 14 and then the ptrace tree was removed ("temporarily", at
Oleg's request) from linux-next on Oct 24.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Feb_2012_13_45_37_+1100_fc=xsDdMl9m=u7BE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPb9RAAoJEECxmPOUX5FE0VAQAIzElkqC3S4xe3DO8Ds4nGgt
hwUS+xAaKRTM8s3iOqrp7hgKEP1fTeAKATIlejihRRU+yYY6/MBHhrn0c6+QXm77
B/4+1ZkzJcmwO/T+DVmEC6wdmKqj+fikCLFWvAl0pb2iPER4lm8ltmoNeoN+ey7U
k0Nkfqbwc57K6FHXAduakDXlQq1jAS0kvDLSqhTjiA6euxd8wWLy3xTxA6n4pFTJ
VGcyiwvlw3ex5+oVp7mwJwNuhQ8xptMBvQ+yyMCjolq29tHn1s0bp6EfJSB/VkCm
EfxK0z9flFO1X/yIKXvC+a0RnLilOeZzH9EAz1groNiVpLSp+NyvOx3rCxQLw6Mk
cquS3gFg8Q+DnOTYuswRIJv2mc7QTjcc/cpiAbX1PRePBN/xAOA5A3UdsRK8PwZZ
FkqBEd19iuvoQNiDQoyxUF8/T9oWzUax7piaGo5/GSMh09k/wMpbIDkAZOS4E3Jj
X/3VSVrxkpfO1EgREVYcagX3J9uN8d9EJPB+CzfRa9L8ZPc9/GoZTFnbgqZodBO1
vWR/GeT9Rtltx2reuvRCub4ZyHBdHOBU7sXD70a63gfSLP9lfqv9EsMTazjxcWZr
jalhiQoS5femPN2RPyLrK9NWDqo2ES2/MfK0vwDdqMBEdNfxeuOIt4LXdEmaMNou
HS/nbVaND8+NyOCH4Bsg
=zArS
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_13_45_37_+1100_fc=xsDdMl9m=u7BE--

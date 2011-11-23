Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1KWNif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:38:35 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53210 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab1KWNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:38:34 -0500
Date: Thu, 24 Nov 2011 00:38:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>, mailsrikar@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v7 3.2-rc2 0/30] uprobes patchset with perf probe
 support
Message-Id: <20111124003814.0c18b5a17eeb348f1a5e1cbc@canb.auug.org.au>
In-Reply-To: <20111123132051.GA23497@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	<20111122050330.GA24807@linux.vnet.ibm.com>
	<20111123014945.5e6cfbf57f7664b3bc1ee2e3@canb.auug.org.au>
	<20111123132051.GA23497@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_00_38_14_+1100_R5vJCqvezS3LO_wM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_00_38_14_+1100_R5vJCqvezS3LO_wM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

On Wed, 23 Nov 2011 18:50:51 +0530 Srikar Dronamraju <srikar@linux.vnet.ibm=
.com> wrote:
>
> I have relooked at the commit messages.=20
> Have also resolve Dan Carpenter's comments on git log --oneline=20
> not showing properly.

Looks better, thanks.

> I have created a for-next branch at git://github.com/srikard/linux.git.

Thanks, I have switched to that.

> My kernel.org account isnt re-activated yet because I still need to
> complete key-signing. I will try to get that done at the earliest.
> Till then, I would have to host on github.

That's ok.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Nov_2011_00_38_14_+1100_R5vJCqvezS3LO_wM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzPdGAAoJEECxmPOUX5FE8EIP/3pvl0lu0KP3qI5VPba8vlc/
LiEIp0xf2akBPQC59pSkXL5s6z7R715zhHB855rZ0kGtnA06TtanUqurxNawmJwG
xdGZkz+vKPJsnsIbZQSDujvvAhZia4/kNQ5YhvshtQlCyG2jlfGDZhAToVfyjXVY
zMFSInRckO4KbBPdQdQ8TulkT4/rgaFCl4ZOXWdbNQasCmrXfH58P+DGMtpjHtR1
5ead+Y+VMgYgz0AeEnNNC9T34cRXRv0jGhEhducpPlUoArpZw9HKYQv8W+dWEroL
kwQjjQRbS3CJI5SQaoZ2SbK/+IhKuQXFDk/kj8gjsR7mDNvgUWmbtdbqJG3SfYcy
0FRm4llOENo5vCwb3Y69+GW42HowFSmq007KXbnQTIfNy37SDEUK281+UIDFLEH/
sXWHbSQHKVOpaodvRG+hoFV6B1i1+n0Uu7TPpKo6YGSJNw0YbqcUk75CAfrqpXQC
QU7uBjmV3a6dEqJ2w+0B0KS5ThgVU+kbkC+J7E/ar5ric2hmV2IqInW+3CnKbBGe
uTFofQ1A06y+/I5ESCkLCf97uCBrJI07x/i7dQBiDTdAAS4bK9Fq3bfbEOVUc5se
HUXURIm85ig4WN6UoiGLESU/h6wd4feBCJBYRlmZIovlfmFY1Ejgp+IJaOnd6pgq
qkY6kAzl/ERg38ty2bQV
=jAhR
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_00_38_14_+1100_R5vJCqvezS3LO_wM--

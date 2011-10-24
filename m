Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1JXSH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 14:07:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54678 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1JXSH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 14:07:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Anton Blanchard <anton@samba.org>, David Ahern <daahern@cisco.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 4/4] perf symbols: Increase symbol KSYM_NAME_LEN size
In-Reply-To: Your message of "Sun, 23 Oct 2011 17:12:23 -0200."
             <1319397143-20301-5-git-send-email-acme@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <1319397143-20301-1-git-send-email-acme@infradead.org>
            <1319397143-20301-5-git-send-email-acme@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319479512_2592P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Oct 2011 14:05:12 -0400
Message-ID: <11382.1319479512@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4EA5A8DA.017A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319479512_2592P
Content-Type: text/plain; charset=us-ascii

On Sun, 23 Oct 2011 17:12:23 -0200, Arnaldo Carvalho de Melo said:

> Fglrx propietary driver has symbol names over 128 chars (:S). This
> breaks the function kallsyms__parse.

Well, that explains why they haven't upstreamed the driver, it will never
pass checkpatch's line-lenght check :)

But at some point you really need to just tell the vendors to put down
the crack pipe.

(What *are* the symbols? C++ mangled function names?)

--==_Exmh_1319479512_2592P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpajYcC3lWbTT17ARAkUZAKCF0nXlG6wfr2aXs7lFnzJe2hz88gCgnZK4
ZJkGng5vyYKsKC464MNYH4c=
=RoIl
-----END PGP SIGNATURE-----

--==_Exmh_1319479512_2592P--


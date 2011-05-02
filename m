Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1EBPRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:17:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46562 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1EBPRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:17:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Michal Marek <mmarek@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
In-Reply-To: Your message of "Mon, 02 May 2011 13:13:37 +0200."
             <20110502111337.GA15769@sepie.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <20110502121817.645d544e.sfr@canb.auug.org.au> <20110502022417.GA11804@redhat.com> <20110502134524.40da4245.sfr@canb.auug.org.au> <20110502142454.a7091ad5.sfr@canb.auug.org.au> <20110502145338.7be2fdbc.sfr@canb.auug.org.au>
            <20110502111337.GA15769@sepie.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304349435_5428P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 May 2011 11:17:15 -0400
Message-ID: <10763.1304349435@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4DBECAFD.0135,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304349435_5428P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 May 2011 13:13:37 +0200, Michal Marek said:

> +# We test for support of the -Wunused-but-set-variable option, because
> +# some version of gcc will happily accept any -Wno-* switch and complain
> +# later during build.
> +ifeq ($(call cc-option-yn, -Wunused-but-set-variable), y)
> +KBUILD_CFLAGS += -Wno-unused-but-set-variable
> +endif

Do we need to do this more generically for all the other -Wno-foo
options under the various W={123} options?

--==_Exmh_1304349435_5428P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNvsr7cC3lWbTT17ARAqtSAJ4zFhvO0wNswHN1loAzlpf087c8DwCeOub/
k57Xfh3FXL2eBXiClbJSGk8=
=Fupw
-----END PGP SIGNATURE-----

--==_Exmh_1304349435_5428P--


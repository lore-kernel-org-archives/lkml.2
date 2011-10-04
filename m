Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab1JDP6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:58:24 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38110 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1JDP6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:58:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/4] [TRIVIAL] ftrace/kprobes: Fix an warning typo
In-Reply-To: Your message of "Tue, 04 Oct 2011 19:44:49 +0900."
             <20111004104449.14591.16995.stgit@fedora15>
From: Valdis.Kletnieks@vt.edu
References: <20111004104438.14591.6553.stgit@fedora15>
            <20111004104449.14591.16995.stgit@fedora15>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317743883_10919P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Oct 2011 11:58:03 -0400
Message-ID: <14310.1317743883@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E8B2D0D.007C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317743883_10919P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Oct 2011 19:44:49 +0900, Masami Hiramatsu said:
> Add a space between words.

>  		if (ret == -ENOENT && trace_probe_is_on_module(tp)) {
> -			pr_warning("This probe might be able to register after"
> +			pr_warning("This probe might be able to register after "
>  				   "target module is loaded. Continue.\n");

Better would be to make it all one line.  Keeping a string together trumps the
80-column rule.


--==_Exmh_1317743883_10919P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOiy0LcC3lWbTT17ARAsXDAJ9oAZhEg1gK8QVYem/7V/208WLyFgCg18wo
zak/bU7wYGedQ3k+yBPQSys=
=IMad
-----END PGP SIGNATURE-----

--==_Exmh_1317743883_10919P--


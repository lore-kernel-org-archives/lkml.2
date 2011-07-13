Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1GMAfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 20:35:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58289 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1GMAfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:35:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Pekka Enberg <penberg@kernel.org>
Cc: Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
In-Reply-To: Your message of "Mon, 11 Jul 2011 08:55:19 +0300."
             <CAOJsxLHzXV3MDHH+83iwxaUtO=931Bmq1JRzS=MQx=6wa-wi2w@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net> <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com> <CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com> <CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com> <CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com> <20110710110241.7650e03f.rdunlap@xenotime.net> <alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net> <20110710160722.ae763029.rdunlap@xenotime.net> <alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
            <CAOJsxLHzXV3MDHH+83iwxaUtO=931Bmq1JRzS=MQx=6wa-wi2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1310517312_3427P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jul 2011 20:35:12 -0400
Message-ID: <32171.1310517312@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E1CE842.0083,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1310517312_3427P
Content-Type: text/plain; charset=us-ascii

On Mon, 11 Jul 2011 08:55:19 +0300, Pekka Enberg said:

> The definitions in SubmittingPatches are not hard rules and are, in
> fact, out of date. See Documentation/development-process/5.Posting for
> alternative definitions:
> 
>  - Acked-by: indicates an agreement by another developer (often a
>    maintainer of the relevant code) that the patch is appropriate for
>    inclusion into the kernel.
> 
> and
> 
>  - Reviewed-by: the named developer has reviewed the patch for correctness;
>    see the reviewer's statement in Documentation/SubmittingPatches for more
>    detail.

Unfortunately, SubmittingPatches says:

        By offering my Reviewed-by: tag, I state that:

         (a) I have carried out a technical review of this patch to
             evaluate its appropriateness and readiness for inclusion into
             the mainline kernel.

         (b) Any problems, concerns, or questions relating to the patch
             have been communicated back to the submitter.  I am satisfied
             with the submitter's response to my comments.

         (c) While there may be things that could be improved with this
             submission, I believe that it is, at this time, (1) a
             worthwhile modification to the kernel, and (2) free of known
             issues which would argue against its inclusion.

         (d) While I have reviewed the patch and believe it to be sound, I
             do not (unless explicitly stated elsewhere) make any
             warranties or guarantees that it will achieve its stated
             purpose or function properly in any given situation.

and often, I'm only comfortable stating (b) - often, I'd like to *disavow* both
(a) and (c)(1) - I usually *don't* do a tech review, and may have no opinion as
to whether it's "cooked" enough to be included.  Also, usually, the only "known
issue" from (c)(2) is the one thing I commented on for part (b)...

Comments-Addressed-Acked: anybody? :)



--==_Exmh_1310517312_3427P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOHOhAcC3lWbTT17ARAq1yAJ0bg/xKCh64BFW+q/WMuT9EKeCMqACg3T6f
IC0t1yknxoP5hiVGpY15QQE=
=EYwG
-----END PGP SIGNATURE-----

--==_Exmh_1310517312_3427P--


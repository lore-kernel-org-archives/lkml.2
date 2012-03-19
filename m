Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab2CSV6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:58:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34848 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab2CSV6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:58:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: David Howells <dhowells@redhat.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for March 18, 2012
In-Reply-To: Your message of "Mon, 19 Mar 2012 19:41:44 -0000."
             <8010.1332186104@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <161084.1332177826@turing-police.cc.vt.edu> <1121.1332169437@redhat.com> <20120318235114.GA30497@thor.bakeyournoodle.com> <20120318184105.GC2095@windriver.com> <9942.1332170491@redhat.com>
            <8010.1332186104@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332194213_2016P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Mar 2012 17:56:53 -0400
Message-ID: <184427.1332194213@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4F67ABA8.006C,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332194213_2016P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Mar 2012 19:41:44 -0000, David Howells said:
> Valdis.Kletnieks@vt.edu wrote:
>
> > Umm.. it's not clear to *me* that it's intended to be a negative 16 bit?  Or
> > am I just missing context not present in the patch?
> >
> > (I have no idea if the rest of the patch is OK or not, but that comment
> > didn't give me warm fuzzies....)

> The patch permits a 64-bit hosted assembler to represent a large 32-bit
> unsigned integer (such as 0xfffffff1) as a negative integer where the
> instruction being assembled has a signed immediate operand.

Oh, I understood the gist of the patch.  My question was specifically
regarding the comment saying:

"0xffffe000 is clearly intended to be a negative 16-bit value"

I'd guess it was a negative *32* bit value, unless there's context constraining it to 16....

--==_Exmh_1332194213_2016P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2erpQdmEQWDXROgAQL02A//Q7sZVwekabyqskRqnFU/4cFZEn6bEzaw
JutLQ6EPwPdJtms1aq5yyzbPX8mIbWO+3QMwqt5sqSTthTKch1/8+oQJRHg5AS/a
GxrVEMVDmQZXsBugARk6HEpPXIcdodH0UgaxLXMt3JXN7qdbeNa7+Q+Hzd+Gm7xr
A2H0S1O1zSvRHYGroDUDUaoUyE77C2W7tEOIvYjaSjIrVpmLgqCtXc1lEw+vQGVa
wn+2FlDm9qtxjLfeEj2jvXciUyu32cAcLGIMI03HpC34SjxUCFqimyfPxj9bbI6e
3SybbJMm1d426y0xkT4gUx+Xq6HYGoyTbbizf9p/YOO+Fyx0pt0QFczGufIRGyBD
xqxQ2rZv/SzhfQScx104iFkcKzdKN/4hjPPDv9Q/Xxz52LSHMvNf6pRr68kEcHFc
6gJXmsa/OUvkh3b0Ad/mx/Bzgpl71DfX3s1KvTZFcM+wLHvx+nHiqhuCLw5T0WSE
Nj0uoxaEjqpsw4M7XDBx2ors3KDza0KggEoqSLPF72NqYWpjRp7amjxIi0oWGdM4
PbtVW3OgrBUYzaaNVj6VaDa95r9ppaKv09ipRa/JUY+IkDVb99DJq1JmA9E4iYwd
I7RQY1ce0Ix3ysg0fH4mWVBtLIAIjoIXeuxtmK3EtSdvPNW3wmo4U2LFcQ8g7K2f
lgU2zrksYTQ=
=EKTq
-----END PGP SIGNATURE-----

--==_Exmh_1332194213_2016P--


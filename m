Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1JPVuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 17:50:55 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42986 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1JPVuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 17:50:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mattia Dongili <malattia@linux.it>
Cc: John Hughes <john@calvaedi.com>, linux-kernel@vger.kernel.org,
        Stelian Pop <stelian@popies.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
In-Reply-To: Your message of "Mon, 17 Oct 2011 06:38:01 +0900."
             <20111016213800.GA12703@kamineko.org>
From: Valdis.Kletnieks@vt.edu
References: <4E9ABBF6.3000504@calvaedi.com> <4E9ADBD3.4070404@calvaedi.com> <4E9B182A.3020101@calvaedi.com> <74494.1318789218@turing-police.cc.vt.edu>
            <20111016213800.GA12703@kamineko.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318801813_43181P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 16 Oct 2011 17:50:13 -0400
Message-ID: <81436.1318801813@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E9B5199.0083,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318801813_43181P
Content-Type: text/plain; charset=us-ascii

On Mon, 17 Oct 2011 06:38:01 +0900, Mattia Dongili said:
> On Sun, Oct 16, 2011 at 02:20:18PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > Do we know if this is applicable to all Sony laptops, or only a few busticated
> > models?
>
> I believe the latter is the case, the old A series also had this
> problem. Of course applying the patch will break other models (SZ is one
> I'm sure about) so there is no actual winner here unless we figure out
> how to properly decode keys on sonypi models (this problem is
> specifically related to two phase hotkey decoding, see the irq handler).

And let me guess - two phase hotkey decoding is sufficiently weird that
nobody wants to actually fix *that* code, right? (Rhetorical question, I
already know the answer to that one).

If that's not an option, perhaps we need a per-model quirk that patches up the
tables at boot time?  If we do that, we may want to re-arrange the table so the
affected entries are at the front or something to help insure we don't patch
the wrong entries if somebody else inserts new lines.


--==_Exmh_1318801813_43181P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOm1GVcC3lWbTT17ARAjcAAKDulcPEJhmcB47OTUZQfj9tZtjRWACfS7Bc
WTN6JHAzVNRR5TXDrqMNFFk=
=DzNM
-----END PGP SIGNATURE-----

--==_Exmh_1318801813_43181P--


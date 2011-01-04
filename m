Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab1ADUcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:32:10 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47539 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1ADUcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:32:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andreas Dilger <adilger@dilger.ca>
Cc: yangsheng <sickamd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        swhiteho@redhat.com, sickadm@gmail.com
Subject: Re: [PATCH resend] Update atime from future.
In-Reply-To: Your message of "Tue, 04 Jan 2011 12:13:37 MST."
             <2321F6F6-1042-48E8-9F21-12C52E8FFFCC@dilger.ca>
From: Valdis.Kletnieks@vt.edu
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com> <13585.1294165307@localhost>
            <2321F6F6-1042-48E8-9F21-12C52E8FFFCC@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294173112_4985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Jan 2011 15:31:53 -0500
Message-ID: <32922.1294173113@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D2383BA.0210,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294173112_4985P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Jan 2011 12:13:37 MST, Andreas Dilger said:
> On 2011-01-04, at 11:21, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 04 Jan 2011 16:56:58 +0800, yangsheng said:
> >> If atime has been wrong set to future, then it cannot
> >> be updated back to current time.
> >>
> >> +#define RELATIME_MARGIN (24 * 60 * 60)
> >
> > Nice patch overall.  Should this be a #define, or a CONFIG_ variable,
> > or a tweakable /proc/sys/fs variable?  Or am I senile and we thrashed
> > all this out once before when the relatime code landed?
> 
> I recall the consensus was that a /proc tunable was "too much" for the
> initial patch.

OK, in that case yangsheng's patch is probably good to go.

--==_Exmh_1294173112_4985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNI4O4cC3lWbTT17ARAiu9AJ0euXfuXHiuJaHBrHFNYbLgZXa8WwCggoWs
7fAScYXgoMiKgEyZbDQFCGw=
=nh0T
-----END PGP SIGNATURE-----

--==_Exmh_1294173112_4985P--


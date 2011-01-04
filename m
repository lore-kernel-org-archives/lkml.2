Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1ADSWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:22:07 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39788 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1ADSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:22:05 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: yangsheng <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, adilger@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        swhiteho@redhat.com, sickadm@gmail.com
Subject: Re: [PATCH resend] Update atime from future.
In-Reply-To: Your message of "Tue, 04 Jan 2011 16:56:58 +0800."
             <1294131418-3835-1-git-send-email-sickamd@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294165307_4985P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Jan 2011 13:21:47 -0500
Message-ID: <13585.1294165307@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4D23653C.0196,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294165307_4985P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Jan 2011 16:56:58 +0800, yangsheng said:
> If atime has been wrong set to future, then it cannot
> be updated back to current time.

> +#define RELATIME_MARGIN (24 * 60 * 60)

Nice patch overall.  Should this be a #define, or a CONFIG_ variable,
or a tweakable /proc/sys/fs variable?  Or am I senile and we thrashed
all this out once before when the relatime code landed?

--==_Exmh_1294165307_4985P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNI2U7cC3lWbTT17ARAgywAKD5Q+Q1kKqpD2mF0s1qbTE+kJDevQCgleQK
nHQxjWnb1lqjWD6K7A8nLco=
=EK1/
-----END PGP SIGNATURE-----

--==_Exmh_1294165307_4985P--


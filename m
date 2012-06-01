Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2FAA2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 20:28:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37298 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab2FAA2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 20:28:13 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Anyone successfully booted a custom kernel on Fedora 17?
In-Reply-To: Your message of "Wed, 30 May 2012 20:15:35 -0700."
             <4FC6E257.4070608@candelatech.com>
From: valdis.kletnieks@vt.edu
References: <4FC6B85C.20201@candelatech.com>
            <4FC6E257.4070608@candelatech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1338510488_2076P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 31 May 2012 20:28:08 -0400
Message-ID: <23353.1338510488@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.180 mail-yx0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4FC80C9C.006B,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1338510488_2076P
Content-Type: text/plain; charset=us-ascii

On Wed, 30 May 2012 20:15:35 -0700, Ben Greear said:
> On 05/30/2012 05:16 PM, Ben Greear wrote:
> > This is probably a Fedora 17 issue..but hoping someone will have mercy on me :)
>
> Must be something to do with my kernel config or how I generate
> the initrd with mkinitrd:

For what it's worth, over on the Rawhide side of the fence, dracut-018-74
builds bad initramfs images for me,while dracut-081-53 works.  Not sure
what release is in the F17 updates repository.  I'm going to file a bug report
with Fedora soon as I figure out what -74 is doing wrong.

--==_Exmh_1338510488_2076P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT8gMmAdmEQWDXROgAQKElxAAq0YgxbH/62OP8wEY5RmW1h1FRKtd53Tg
i32/NRQ7stsCP1tbn1bROvVOz6dXpnZ+vchxhjqEVYJgDBSUy+RJtbc8sdBXT+0N
mKXkp/t45sNHDnEPrcgiPW+pyA8ZI+6JXszx+GlkpvwlEN1Ew7afQjhVay5RQRI5
8Tqj8/rkCaxeYFCmbsbYPkjupTUCv7NReZi5sEQ+wFMhUAvkPEtDcIOZYwMV6vEk
5dDf+htFMQNR+VlTGa1OEWHoNFC6gvPhM4Jtu8dV5igzkmtwZ6WpBfYzLEx2Jr7q
4Oz/Ty8DuPTzLAenqDNW9n3lwxyM3P9kaFPlarTwwqCeORihegVaaZNSMpMg1Bbh
zhi2W9TTJ3lPLqxGlCOCqBkm6fLuQg582IRPzKSPfta8al7O2WGQUEh8Yx7nIJaU
dmpFDp6v3u0VoQX+sxebOmF1kgVJ7eQu+xvqLQ4hfgkpO4fawE9Op0+fVw+OL9cy
vrHwcOJDLTt9Uhvvl/7V0mXu+GNABHIFv09/nZlP80PCeZiOrdrIVp8vJ9jYTgoY
cc55kYceZP8P+mFslesm3IMe1kvlzTiYR7mOHIBNwhQ2zO3opnsWWYGneFlL7oGQ
2CIZESvYTmaq4XJ83AUeDT3D1pI2ZDExZQ6YarPF0di0DJ2WxgSvo2/FNa+JbaNS
FimNfC6Pg08=
=6dHj
-----END PGP SIGNATURE-----

--==_Exmh_1338510488_2076P--


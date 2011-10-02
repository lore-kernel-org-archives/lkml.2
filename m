Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1JBUmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:42:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53930 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485Ab1JBUmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:42:10 -0400
X-Sasl-enc: 8unEkHDZ9gidMRL25oTLAFcpkVkcHSrRr0MiP4kPOQ95 1317588129
Date: Sun, 2 Oct 2011 17:42:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111002204205.GD16368@khazad-dum.debian.net>
References: <4E8655CD.90107@zytor.com>
 <201110022014.27549.rjw@sisk.pl>
 <4E88AE07.2080603@zytor.com>
 <201110022131.28649.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110022131.28649.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Oct 2011, Rafael J. Wysocki wrote:
> Yes, it does, except that it will leave the people not at the KS and
> unable to create their own small webs of trust somewhat in the dust.

Look outside LKML.  For example, try to locate a Debian developer near
you, it shouldn't be too dificult[0] and you are almost guaranteed to
join the web-of-trust strong set[1] if you get your key cross-signed
with a Debian Developer[2].

[0] http://www.debian.org/devel/developers.loc

[1] The strong set is the largest set of keys such that for any two keys
in the set, there is a path from one to the other, refer to:
http://pgp.cs.uu.nl/plot/

[2] Based on the report from 2/17/08, an examination of 201,989 publicly
available keys found a strong set of 110,957 keys (about 54% of the
sample). In this strong set, the average MSD was 6.3449. The most
connected key belongs to Peter Palfrader and has an MSD of 3.5588. One
interesting phenomenon is that all of the top (most connected) 25 keys
and all but 12 of the top 50 keys belong to people involved with the
Debian project. The Debian project relies very heavily on GPG for
authentication and demands that members be in the web of trust before
they can join.  Quoted from:
http://expertvoices.nsdl.org/cornell-info204/2008/02/28/pgpgpg-the-web-of-trust-and-the-strong-set/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

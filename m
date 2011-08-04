Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1HDLMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:12:07 -0400
Received: from frost.carfax.org.uk ([212.13.194.111]:55822 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1HDLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:12:05 -0400
Date: Thu, 4 Aug 2011 12:12:02 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: JA Magallon <jamagallon@ono.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Metadata space in BTRFS
Message-ID: <20110804111202.GD28326@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	JA Magallon <jamagallon@ono.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20110804014234.01d9f05a@werewolf.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Content-Disposition: inline
In-Reply-To: <20110804014234.01d9f05a@werewolf.home>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: -0.7 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "spamd1.lon.bitfolk.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  [cc linux-btrfs added] On Thu, Aug 04, 2011 at 01:42:34AM
   +0200, JA Magallon wrote: > Hi all... > > Just a simple question. > I'm trying
    to use a 16GB SDHC card formatted in btrfs, and the system > eats about 2GB
    for its metadata space. When the card fills, the > situation is like this:
    > > werewolf:/media/home# btrfs fi df . > Data: total=13.22GB, used=13.22GB
    > System, DUP: total=8.00MB, used=4.00KB > System: total=4.00MB, used=0.00
    > Metadata, DUP: total=1.00GB, used=58.43MB > Metadata: total=8.00MB, used=0.00
    > > I lose about 2Gb wrt ext4. Is there any way to shrink this metadata >
    space ? > > TIA > [...] 
 Content analysis details:   (-0.7 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.7 RP_MATCHES_RCVD        Envelope sender domain matches handover relay domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[cc linux-btrfs added]

On Thu, Aug 04, 2011 at 01:42:34AM +0200, JA Magallon wrote:
> Hi all...
> 
> Just a simple question.
> I'm trying to use a 16GB SDHC card formatted in btrfs, and the system
> eats about 2GB for its metadata space. When the card fills, the
> situation is like this:
> 
> werewolf:/media/home# btrfs fi df .
> Data: total=13.22GB, used=13.22GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=58.43MB
> Metadata: total=8.00MB, used=0.00
> 
> I lose about 2Gb wrt ext4. Is there any way to shrink this metadata
> space ?
> 
> TIA
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- But somewhere along the line, it seems / That pimp became ---    
                       cool,  and punk mainstream.                       

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOOn6CIKyzvlFcI40RAqJBAJ4j/phLrq/r4Rh167FOODv7xFEjSQCghA/C
eYuH13aCXyUNyVKfIT+dcE0=
=J5X2
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--

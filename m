Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0G0Wuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:50:51 -0400
Received: from mail.copilotco.com ([216.105.40.123]:45920 "EHLO
	mail.copilotco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0G0Wuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:50:50 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2010 18:50:50 EDT
Date: Tue, 27 Jul 2010 15:29:16 -0700
From: Tracy Reed <treed@ultraviolet.org>
To: bchociej@gmail.com
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
        mrlupfer@us.ibm.com, crscott@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Message-ID: <20100727222916.GM18595@tracyreed.org>
Mail-Followup-To: Tracy Reed <treed@ultraviolet.org>, bchociej@gmail.com,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com,
	linux-kernel@vger.kernel.org
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/eUdp+dLtKXvemk"
Content-Disposition: inline
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 27, 2010 at 05:00:18PM -0500, bchociej@gmail.com spake thusly:
> The long-term goal of these patches, as discussed in the Motivation
> section at the end of this message, is to enable Btrfs to perform
> automagic relocation of hot data to fast media like SSD. This goal has
> been motivated by the Project Ideas page on the Btrfs wiki.

With disks being so highly virtualized away these days is there any
way for btrfs to know which are the fast outer-tracks vs the slower
inner-tracks of a physical disk? If so not only could this benefit SSD
owners but it could also benefit the many more spinning platters out
there. If not (which wouldn't be surprising) then disregard. Even just
having that sort of functionality for SSD would be excellent. If I
understand correctly not only would this work for SSD but if I have a
SAN full of many large 7200rpm disks and a few 15k SAS disks I could
effectively utilize that disk by allowing btrfs to place hot data on
the 15k SAS. I understand Compellent does this as well.

--=20
Tracy Reed
http://tracyreed.org

--9/eUdp+dLtKXvemk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFMT128BhSTPg0d/nQRAhBOAKCvjeQkmnXPZfOKLMH77Uqf/wq/eQCg3Jlj
bLgbNEtYOD8rwMexPC+8lOU=
=jetJ
-----END PGP SIGNATURE-----

--9/eUdp+dLtKXvemk--

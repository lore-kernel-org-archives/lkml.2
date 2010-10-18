Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0JRLOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:14:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50091 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754636Ab0JRLOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:14:33 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18t7xUJbXstn7DObI6Iy9KYIuXDe538o9gms8aoJl
	X7YfSXgR1j63SP
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
Date: Mon, 18 Oct 2010 13:14:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
Cc: Christoph Hellwig <hch@lst.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <201010131328.06465.toralf.foerster@gmx.de> <201010181105.17077.toralf.foerster@gmx.de> <AANLkTi=UyWg6PUrE_jEs0oqZ_tVw1mMQsoUrDnnqtcHa@mail.gmail.com>
In-Reply-To: <AANLkTi=UyWg6PUrE_jEs0oqZ_tVw1mMQsoUrDnnqtcHa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010181314.27780.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard -rw- weinberger wrote at 11:31:31
> Does this help?
> 
> --- linux-2.6.36-rc8/fs/hostfs/hostfs_user.c.orig       2010-10-18
> 11:24:33.844592000 +0200
> +++ linux-2.6.36-rc8/fs/hostfs/hostfs_user.c    2010-10-18
> 11:24:44.594679000 +0200
> @@ -388,6 +388,6 @@
>         spare_out[1] = buf.f_spare[1];
>         spare_out[2] = buf.f_spare[2];
>         spare_out[3] = buf.f_spare[3];
> -       spare_out[4] = buf.f_spare[4];
> +
>         return 0;
>  }

yes - definitely (BTW I like a preceeding "diff --git" line to make the patch 
utility happy ;) )

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


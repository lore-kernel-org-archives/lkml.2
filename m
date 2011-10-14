Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1JNFsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:48:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44548 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab1JNFra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Markus Rechberger <mrechberger@gmail.com>
Cc: James Courtier-Dutton <james.dutton@gmail.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: Your message of "Fri, 14 Oct 2011 05:42:44 +0200."
             <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com> <20111012141724.GA17414@suse.de> <CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com> <20111012203337.GA14572@suse.de> <CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com> <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com> <CAAMvbhFNTQeuJBgsDB9Y5ODc_b2O0X=oP_3uwRpWUREFS9qufA@mail.gmail.com> <CA+O4pCK2=rjqufLetTd=419bDfkN6RRX89Sh5noDnjoBAgoR2A@mail.gmail.com>
            <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318571233_28908P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Oct 2011 01:47:13 -0400
Message-ID: <79856.1318571233@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E97CCE5.005E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318571233_28908P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Oct 2011 05:42:44 +0200, Markus Rechberger said:

> The inflexible device which uses 24064 bytes works with all other
> Operating systems by using that value
> and gives exactly the same results with other transfer sizes than that.

-ENOPARSE.  If it's inflexible, how did you get results for other transfer
sizes? And if other transfer sizes give exactly the same results, why can't you
just use those instead?


--==_Exmh_1318571233_28908P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOl8zhcC3lWbTT17ARAnVxAKCagwq0juFFw392tL6Oi4IFs+vm3wCfUY3y
TbqyrQCa+zBmfe++SyqXNvM=
=mJ3I
-----END PGP SIGNATURE-----

--==_Exmh_1318571233_28908P--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1DZTMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:12:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45162 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1DZTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:12:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: Wonkiness with keyboard adapter - not sure if it's in USB or input systems
In-Reply-To: Your message of "Tue, 26 Apr 2011 14:55:57 EDT."
             <Pine.LNX.4.44L0.1104261453300.2035-100000@iolanthe.rowland.org>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.44L0.1104261453300.2035-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303845136_5095P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Apr 2011 15:12:16 -0400
Message-ID: <23191.1303845136@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4DB71911.012B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1303845136_5095P
Content-Type: text/plain; charset=us-ascii

On Tue, 26 Apr 2011 14:55:57 EDT, Alan Stern said:
> On Tue, 26 Apr 2011 Valdis.Kletnieks@vt.edu wrote:

> > Bus 001 Device 006: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter

> Have you tried testing the adapter by plugging it in after the system 
> is running?

It works fine at the Grub screen.

It *doesn't* work for the kernel when it initially starts up, even though a few
seconds ago the hardware worked just fine.

It *does* work after I've unplugged/replugged it - I've tested both the USB
side and the PS2 side, in either case it starts working.

I'm not sure what difference "plug it in after it's running" and "unplug/
replug" will have. I suppose I could test that, but I'm suspecting the results
will be "it works fine after plugging it in once the kernel is up".


--==_Exmh_1303845136_5095P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNtxkQcC3lWbTT17ARAhOxAKCT3S9UY9IRkLRocak5M5Y16ZwvOACgrvij
I9nkCLDCmulzJDMafWyQe7k=
=eOQ1
-----END PGP SIGNATURE-----

--==_Exmh_1303845136_5095P--


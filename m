Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1CQW6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:58:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48227 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1CQW6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:58:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Greg KH <gregkh@suse.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II
In-Reply-To: Your message of "Thu, 17 Mar 2011 14:45:37 PDT."
             <20110317214537.GA28608@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <1300226527-26933-1-git-send-email-kys@microsoft.com> <20110315220454.GC30390@suse.de> <30255.1300397967@localhost>
            <20110317214537.GA28608@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1300402705_5386P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 17 Mar 2011 18:58:25 -0400
Message-ID: <34155.1300402705@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4D829212.00B9,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1300402705_5386P
Content-Type: text/plain; charset=us-ascii

On Thu, 17 Mar 2011 14:45:37 PDT, Greg KH said:
> On Thu, Mar 17, 2011 at 05:39:27PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > Is that Linus's merge window, or your window to freeze a for-linus tree?
> 
> My window.
> 
> Linus's merge window is for the subsystem maintainers.  Everything that
> is to be sent during Linus's merge window had to be in the linux-next
> tree for a bit of time before the merge window opens.

OK, that's what I suspected, but wasn't 100% sure, because..

> I also posted the "my tree is now closed for .39 stuff" message to the
> devel mailing list, so there shouldn't have been any questions about
> this.

some of us are only on lkml, where usually it's Linus who gets to say
"The 2.6.N merge window is closed".

--==_Exmh_1300402705_5386P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNgpIRcC3lWbTT17ARAprJAKCxRA+iIwOFAheeolLxEEpiMUBQvQCeO1E2
vE+Hwf4L+bRx4wxrh8WBGtc=
=Kql9
-----END PGP SIGNATURE-----

--==_Exmh_1300402705_5386P--


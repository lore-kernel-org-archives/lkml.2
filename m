Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0GURgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:36:50 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58626 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab0GURgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:36:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel/panic.c warn_slowpath_common printk timestamp weirdness
In-Reply-To: Your message of "Wed, 21 Jul 2010 06:36:41 PDT."
             <4C46F7E9.3070200@linux.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <62021.1279716868@localhost>
            <4C46F7E9.3070200@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1279733737_4583P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Jul 2010 13:35:37 -0400
Message-ID: <6895.1279733737@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C47300A.011A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1279733737_4583P
Content-Type: text/plain; charset=us-ascii

On Wed, 21 Jul 2010 06:36:41 PDT, Arjan van de Ven said:
> On 7/21/2010 5:54 AM, Valdis.Kletnieks@vt.edu wrote:
> > Seeing this on my Dell Latitude.  The timestamps from the 'cut here' and
> > WARNING lines are different even though they're issued by sequential lines 
in
> > panic.c - but then the printk timestamps remain identical even through an
> > *entire second* WARN call.  Is somebody blocking clock interrupts and faili
ng
> > to re-enable them, or is something different going on here?
> >
> > [42875.543219] ------------[ cut here ]------------
> > [42875.544006] WARNING: at lib/plist.c:57 plist_check_head+0x47/0x114()
> >    
> 
> > [42875.544006] WARNING: at lib/plist.c:57 plist_check_head+0x47/0x114()
> > [42875.544006] Hardware name: Latitude E6500
> >    
> 
> > [42882.428016] ------------[ cut here ]------------
> > [42882.428016] WARNING: at lib/plist.c:57 plist_check_head+0x47/0x114()
> >    
> 
> 
> Maybe I have not have had coffee yet.. but I don't see the one second 
> jump in the three cases you mailed...

I mean the value stays nailed down, even through a second WARN call - it outputs
two entire WARN tracebacks with the exact same timestamp.  Even if the same
timestamp gets used for the traceback, I'd expect the next 'cut here' to have a
new timestamp, and the second WARN trace to have a different timestamp as
well.


--==_Exmh_1279733737_4583P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMRy/pcC3lWbTT17ARAnXPAKCD4Cth2t3kT81WcfTJR7srEMuV7gCfVBnZ
Q6/ez2NqlGPSadN4p/62Pp0=
=zn2i
-----END PGP SIGNATURE-----

--==_Exmh_1279733737_4583P--


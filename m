Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0EZSyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:54:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57846 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0EZSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:54:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arve Hj?nnev?g <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
In-Reply-To: Your message of "Wed, 26 May 2010 13:23:00 CDT."
             <1274898180.4467.925.camel@mulgrave.site>
From: Valdis.Kletnieks@vt.edu
References: <1274863342.5882.4850.camel@twins> <20100526112303.3fef15a4@schatten.dmk.lab> <1274866402.5882.5051.camel@twins> <AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com> <1274868384.5882.5169.camel@twins> <AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com> <1274869262.5882.5222.camel@twins> <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com> <1274890736.4467.574.camel@mulgrave.site> <1274891308.1674.1766.camel@laptop> <20100526165919.GB2089@elf.ucw.cz> <1274893309.1674.1773.camel@laptop> <1274894685.4467.758.camel@mulgrave.site> <alpine.LFD.2.00.1005261948290.2995@localhost.localdomain>
            <1274898180.4467.925.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1274899857_4200P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 May 2010 14:50:57 -0400
Message-ID: <15650.1274899857@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4BFD6D92.0197,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1274899857_4200P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 May 2010 13:23:00 CDT, James Bottomley said:
> On Wed, 2010-05-26 at 19:51 +0200, Thomas Gleixner wrote:
> > Darn, _we_ have to deal with that forever as it sets a crappy user
> > space ABI in stone.
> 
> I really don't see how it is ... the ABI comes with a switch that allows
> it to be disabled, so only platforms wishing to use it have to support
> it.  Even on those platforms that do support it, we can translate most
> of it into pm QoS stuff and if one day someone solves the rogue app
> problem, we can migrate over.

And yet, the OSS drivers are *still* in-tree, even though similar arguments
apply to an OSS->ALSA migration.  And there's a bunch of other stuff in
Documentation/feature-removal-schedule.txt in a similar situation.

Remember - programming is like sex. One poorly planned release and you're
stuck maintaining it for years. :)

--==_Exmh_1274899857_4200P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL/W2RcC3lWbTT17ARAvoDAKC9rHsYHH8ofLPpJII9kWXkNeMXygCg7qSL
pOtBEw3pezX5Nm/KYZDX3xk=
=BHVJ
-----END PGP SIGNATURE-----

--==_Exmh_1274899857_4200P--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab0EMQaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:30:22 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58313 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab0EMQaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:30:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded
In-Reply-To: Your message of "Thu, 13 May 2010 13:20:50 -0300."
             <4BEC26E2.1020404@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org> <6195.1273763194@localhost> <20100513160249.GC22238@core.coreip.homeip.net>
            <4BEC26E2.1020404@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273768199_3844P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 May 2010 12:29:59 -0400
Message-ID: <10741.1273768199@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4BEC2908.008A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273768199_3844P
Content-Type: text/plain; charset=us-ascii

On Thu, 13 May 2010 13:20:50 -0300, Mauro Carvalho Chehab said:
> Dmitry Torokhov wrote:
> > On Thu, May 13, 2010 at 11:06:34AM -0400, Valdis.Kletnieks@vt.edu wrote:
> >> On Tue, 11 May 2010 18:21:22 PDT, akpm@linux-foundation.org said:
> >>> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
> >>>
> >>>    http://userweb.kernel.org/~akpm/mmotm/
> >> Dell Latitude E6500, x86_64 kernel.
> >>
> >> Boots to single user prompt, but has issues on the way there.  Possibly
> >> very important - I was definitely *not* typing at the time (as I had hit
> >> return on the LUKS passphrase for the disk at 36 seconds after boot, and
> >> I didn't get the # prompt for single-user for another minute or two (probably
> >> due to udev having issues due to the oops). So I have no idea what it was
> >> trying to get a keycode for...
> >>
> > 
> > Udev probably tries to remap special keys on your keyboard...
> > 
> >> [   40.717136] udev: starting version 154
> >> [   41.710153] BUG: unable to handle kernel NULL pointer dereference at (null)
> >> [   41.711007] IP: [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
> >> [   41.711007] PGD 11d318067 PUD 118af1067 PMD 0
> >> [   41.711007] Oops: 0002 [#1] PREEMPT SMP
> >> [   41.711007] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/idVendor
> >> [   41.711007] CPU 0
> >> [   41.711007] Modules linked in:
> >> [   41.711007]
> >> [   41.711007] Pid: 2501, comm: keymap Not tainted 2.6.34-rc7-mmotm0511 #2 0X564R/Latitude E6500
> >>
> >> [   41.711007] RIP: 0010:[<ffffffff813bb996>]  [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
> > 
> > I think this is Mauro's big keycode additions.
> 
> Yes, it is likely. It may be caused by some bad conflict resolution between both git trees.
> I'll handle this bug.

Feel free to let me know if there's any testing/instrumentation you want done...


--==_Exmh_1273768199_3844P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL7CkHcC3lWbTT17ARArZFAJ9zqpdPD0344HPd5HjtXdDLDGSnRwCghRLm
MB+mV//iH3ZcOgY5GsmxfcE=
=EvLc
-----END PGP SIGNATURE-----

--==_Exmh_1273768199_3844P--


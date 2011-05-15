Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1EPPW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:22:58 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:42111 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab1EPPW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:22:57 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 11:22:57 EDT
From: "Luke-Jr" <luke@dashjr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #33662] System hangs during X startup (kwin compositing?)
Date: Sat, 14 May 2011 21:51:14 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.37-gentoo-r4-AMD; KDE/4.4.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Luke-Jr" <luke-jr+linuxbugs@utopios.org>
References: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera> <SFkDk2sBn_E.A.ARD.zQwzNB@chimera>
In-Reply-To: <SFkDk2sBn_E.A.ARD.zQwzNB@chimera>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105142151.18208.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 14, 2011 6:40:40 pm Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33662
> Subject		: System hangs during X startup (kwin compositing?)
> Submitter	: Luke-Jr <luke-jr+linuxbugs@utopios.org>
> Date		: 2011-04-19 04:26 (26 days old)
> First-Bad-Commit:
> http://git.kernel.org/linus/e8616b6ced6137085e6657cc63bc2fe3900b8616

I assume, since the bug has not had any comments to the contrary, that it is 
still an outstanding regression. I have been using 2.6.37 until I have some 
reason to think there is something ready for testing...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0JKUOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:14:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab0JKUOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:14:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: [Bug #16462] unable to connect to hidden SSID AP on legal channel 13
Date: Mon, 11 Oct 2010 22:13:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera> <yeAD7A8RDxC.A.xu.dxgsMB@chimera> <C5C86A19469DAE48AAAD0E5F3716E44501D3D355C4@irsmsx504.ger.corp.intel.com>
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D3D355C4@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010112213.48137.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 11, 2010, Berg, Johannes wrote:
> Rafael,
> 
> I believe that we have fixed the part of this bug that was a regression,
> namely being unable to connect to a non-hidden SSID, in 2.6.35 commit
> 3ee378d7e0dfdb9bb. Being able to connect to a hidden SSID I believe isn't a
> regression, and a patch for that is on its way upstream for 2.6.37. I think
> you should stop tracking this as a regression.

OK, I've closed the bug.

Thanks,
Rafael


> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > Sent: Sunday, October 10, 2010 9:19 PM
> > To: Linux Kernel Mailing List
> > Cc: Kernel Testers List; Maciej Rutecki; Florian Mickler; Daniel J
> > Blueman; Berg, Johannes
> > Subject: [Bug #16462] unable to connect to hidden SSID AP on legal
> > channel 13
> > 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16462
> > Subject		: unable to connect to hidden SSID AP on legal
> > channel 13
> > Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
> > Date		: 2010-07-25 17:06 (78 days old)
> > Handled-By	: Johannes Berg <johannes.berg@intel.com>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=31862
> > 
> 
> --------------------------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen, Deutschland 
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 
> Ust.-IdNr./VAT Registration No.: DE129385895
> Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
> 


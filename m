Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1BCSoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:44:20 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:42563 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab1BCSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:44:19 -0500
Date: Thu, 3 Feb 2011 19:44:12 +0100
From: Nico Schottelius <nico-kernel-20110117@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Nico Schottelius <nico-kernel-20110117@schottelius.org>
Subject: Re: [Bug #28102] New display errors in 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110203184412.GA3956@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-20110117@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>
References: <QUnbpYCwS-F.A.vaC.VHeSNB@chimera>
 <ibChAs1xEQI.A.0gC.aHeSNB@chimera>
 <20110203101111.35d71bf0@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203101111.35d71bf0@jbarnes-desktop>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.37-rc4-00292-g3c8cdf9 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes [Thu, Feb 03, 2011 at 10:11:11AM -0800]:
> On Thu,  3 Feb 2011 00:31:29 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.37.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28102
> > Subject		: New display errors in 2.6.38-rc2-00175-g6fb1b30
> > Submitter	: Nico Schottelius <nico-kernel-20110117@schottelius.org>
> > Date		: 2011-01-28 20:29 (6 days old)
> > Message-ID	: <20110128202905.GB3395@schottelius.org>
> > References	: http://marc.info/?l=linux-kernel&m=129624657425949&w=2
> 
> Does this also occur with the drm-intel-next branch? 

Didn't try this one, went back to 2.6.37-rc4-00292-g3c8cdf9 now.

I thought about following the bisect way, should I go a different
one better?

> Do you have a picture of the corruption?

Not yet, can do one next time. Though I found one that looks
very similar to my corruption:

http://i759.photobucket.com/albums/xx239/ericfx1984/DSCF2469.jpg

Though in my case no character was visible anymore.

Cheers,

Nico


-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

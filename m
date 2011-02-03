Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1BCSxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:53:24 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:50175 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932423Ab1BCSxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:53:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MLvfXdITrvWZdDqWjzDVyK6ZDVeXoQEaps1j8mEatgkm5On54eMKJVY2iG0UaybR5TY7RBA/DN+jBJVNP653UQsSTr4mpJk6OjW6J/awyf2xxE5bDJ3htdpyc/SgFgaz;
Date: Thu, 3 Feb 2011 10:53:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #28102] New display errors in 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110203105319.2711b1db@jbarnes-desktop>
In-Reply-To: <20110203184412.GA3956@schottelius.org>
References: <QUnbpYCwS-F.A.vaC.VHeSNB@chimera>
	<ibChAs1xEQI.A.0gC.aHeSNB@chimera>
	<20110203101111.35d71bf0@jbarnes-desktop>
	<20110203184412.GA3956@schottelius.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 19:44:12 +0100
Nico Schottelius <nico-kernel-20110117@schottelius.org> wrote:

> Jesse Barnes [Thu, Feb 03, 2011 at 10:11:11AM -0800]:
> > On Thu,  3 Feb 2011 00:31:29 +0100 (CET)
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > This message has been generated automatically as a part of a summary report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.37.  Please verify if it still should be listed and let the tracking team
> > > know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28102
> > > Subject		: New display errors in 2.6.38-rc2-00175-g6fb1b30
> > > Submitter	: Nico Schottelius <nico-kernel-20110117@schottelius.org>
> > > Date		: 2011-01-28 20:29 (6 days old)
> > > Message-ID	: <20110128202905.GB3395@schottelius.org>
> > > References	: http://marc.info/?l=linux-kernel&m=129624657425949&w=2
> > 
> > Does this also occur with the drm-intel-next branch? 
> 
> Didn't try this one, went back to 2.6.37-rc4-00292-g3c8cdf9 now.
> 
> I thought about following the bisect way, should I go a different
> one better?

Bisect would also be fine.

> > Do you have a picture of the corruption?
> 
> Not yet, can do one next time. Though I found one that looks
> very similar to my corruption:
> 
> http://i759.photobucket.com/albums/xx239/ericfx1984/DSCF2469.jpg

Interesting, ok.

-- 
Jesse Barnes, Intel Open Source Technology Center

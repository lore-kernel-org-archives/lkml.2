Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1DSVVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:21:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab1DSVVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:21:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hans de Bruin <jmdebruin@xmsnet.nl>
Subject: Re: [Bug #31322] 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
Date: Tue, 19 Apr 2011 23:21:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera> <IqJL5EkbqD.A.MTF.r4uqNB@chimera> <4DAC9C41.7040908@xmsnet.nl>
In-Reply-To: <4DAC9C41.7040908@xmsnet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104192321.56934.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 18, 2011, Hans de Bruin wrote:
> On 04/17/2011 03:52 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.37 and 2.6.38.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31322
> > Subject		: 2.6.38-rc echo 3>  /proc/sys/vm/drop_caches repairs mplayer distortions
> > Submitter	: Hans de Bruin<jmdebruin@xmsnet.nl>
> > Date		: 2011-03-14 21:34 (35 days old)
> > Message-ID	:<4D7E89E7.3080505@xmsnet.nl>
> > References	: http://marc.info/?l=linux-kernel&m=130014181919827&w=2
> >
> 
> The  bug is still there and affecting kernels up to 2.6.39-rc3

Thanks for the update.

Rafael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0KSUHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:07:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37930 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0KSUHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:07:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #19392] WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
Date: Fri, 19 Nov 2010 21:06:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Johannes Berg <johannes@sipsolutions.net>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera> <t78YtCSuOqN.A.IiH.F5b5MB@chimera> <4CE5EFE0.8050604@gmail.com>
In-Reply-To: <4CE5EFE0.8050604@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011192106.18269.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Justin P. Mattock wrote:
> On 11/18/2010 03:53 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19392
> > Subject		: WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
> > Submitter	: Justin Mattock<justinmattock@gmail.com>
> > Date		: 2010-09-28 22:30 (52 days old)
> > Message-ID	:<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=128571307018635&w=2
> 
> yep still there..

Thanks for the update.

Rafael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab0JJTmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:42:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0JJTmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:42:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #19392] WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
Date: Sun, 10 Oct 2010 21:41:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Johannes Berg <johannes@sipsolutions.net>
References: <v0Rsc8XZnFC.A.-xF.oqfsMB@chimera> <xpndfyzv9iD.A.STG.7qfsMB@chimera> <4CB211C7.20809@gmail.com>
In-Reply-To: <4CB211C7.20809@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010102141.45916.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 10, 2010, Justin P. Mattock wrote:
>   On 10/10/2010 10:51 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19392
> > Subject		: WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
> > Submitter	: Justin Mattock<justinmattock@gmail.com>
> > Date		: 2010-09-28 22:30 (13 days old)
> > Message-ID	:<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=128571307018635&w=2
> >
> >
> >
> as far as I know this is still here.. I can pull the latest to see
> if it's been fixed, as well as the wireless tree to see.

Well, please do.

Rafael
